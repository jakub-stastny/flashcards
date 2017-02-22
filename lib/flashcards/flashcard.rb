class Flashcard
  attr_reader :data
  def initialize(data)
    @data = data
    @data[:tags]     ||= Array.new
    @data[:examples] ||= Array.new
    @data[:metadata] ||= Hash.new

    self.expression || raise(ArgumentError.new('Expression has to be provided!'))

    if translation = @data.delete(:translation)
      @data[:translations] = [translation].flatten
    elsif self.translations.is_a?(String)
      @data[:translations] = [self.translations]
    end

    (self.translations && self.translations[0]) || raise(ArgumentError.new('Translations has to be provided!'))

    self.translations.map! do |translation|
      translation.is_a?(Integer) ? translation.to_s : translation
    end



    if silent_translation = @data.delete(:silent_translation)
      @data[:silent_translations] = [silent_translation].flatten
    elsif self.silent_translations.is_a?(String)
      @data[:silent_translations] = [self.silent_translations]
    elsif self.silent_translations.nil?
      @data[:silent_translations] = Array.new
    end

    self.silent_translations.map! do |translation|
      translation.is_a?(Integer) ? translation.to_s : translation
    end




    @data[:expression] = self.expression.to_s if self.expression.is_a?(Integer)

    self.examples.each do |pair|
      if pair.length != 2
        raise ArgumentError.new("Incorrect example: #{pair.inspect}")
      end
    end
  end

  ATTRIBUTES = [
    :expression, :translations, :silent_translations, :note, :hint, :tags, :examples, :metadata
  ]

  ATTRIBUTES.each do |attribute|
    define_method(attribute) { @data[attribute] }
  end

  def data
    @data.dup.tap do |data|
      if self.translations.length == 1
        data[:translation] = self.translations.first
        data.delete(:translations)
      end

      if self.silent_translations.length == 1
        data[:silent_translation] = self.silent_translations.first
        data.delete(:silent_translations)
      end

      if self.silent_translations.empty?
        data.delete(:silent_translations)
      end

      data.delete(:tags) if tags.empty?
      data.delete(:metadata) if metadata.empty?
      data.delete(:examples) if examples.empty?
    end
  end

  def ==(anotherFlashcard)
    self.expression == anotherFlashcard.expression && self.translations.sort == anotherFlashcard.translations.sort
  end

  # TODO: Refactor the code to use it.
  # Also deal with correct_answers.push. Maybe I have to
  # do the same as with metadata, bootstrap it and tear down if empty.
  def correct_answers
    self.metadata[:correct_answers] || Array.new
  end

  def new?
    self.correct_answers.empty?
  end

  SCHEDULE = [1, 5, 25, 125]
  def time_to_review?
    return false if self.new?

    correct_answers = (self.metadata[:correct_answers] || Array.new)
    number_of_days = SCHEDULE[correct_answers.length - 1] || (365 * 2)

    tolerance = (5 * 60 * 60) # 5 hours.
    correct_answers.last < (Time.now - ((number_of_days * 24 * 60 * 60) - tolerance))
  end

  def mark(answer)
    if self.translations.include?(answer) || self.silent_translations.include?(answer)
      self.metadata[:correct_answers] ||= Array.new
      self.metadata[:correct_answers].push(Time.now)
      return true
    else
      self.mark_as_failed
    end
  end

  def mark_as_failed
    self.metadata.delete(:correct_answers) # Treat as new.
    return false
  end
end
