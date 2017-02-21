class Flashcard
  attr_reader :data
  def initialize(data)
    @data = data
    @data[:examples] ||= Array.new
    @data[:metadata] ||= Hash.new

    if translation = @data.delete(:translation)
      @data[:translations] = [translation]
    end

    # Fix incorrect use.
    if self.translations.is_a?(String)
      @data[:translations] = [self.translations]
    end

    self.expression || raise(ArgumentError.new('Expression has to be provided!'))
    (self.translations && self.translations[0]) || raise(ArgumentError.new('Translations has to be provided!'))
  end

  [:expression, :translations, :hint, :examples, :metadata].each do |attribute|
    define_method(attribute) { @data[attribute] }
  end

  def data
    @data.dup.tap do |data|
      if self.translations.length == 1
        data[:translation] = self.translations.first
        data.delete(:translations)
      end
      data.delete(:metadata) if metadata.empty?
      data.delete(:examples) if examples.empty?
    end
  end

  def ==(anotherFlashcard)
    self.expression == anotherFlashcard.expression && self.translations.sort == anotherFlashcard.translations.sort
  end

  def remembered?
    (self.metadata[:correct_answers] || Array.new).length >= 3
  end

  def mark(answer)
    if self.translations.include?(answer)
      self.metadata[:correct_answers] ||= Array.new
      self.metadata[:correct_answers].push(Time.now)
      return true
    else
      self.metadata.delete(:correct_answers) # Treat as new.
      return false
    end
  end
end
