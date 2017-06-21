require 'flashcards' # FIXME: Extract Flashcards.app to flashcards/app.rb and change this.

module Flashcards
  class Example
    attr_reader :expression, :translation, :label, :tags
    def initialize(expression:, translation:, label: nil, tags: Array.new)
      @expression, @translation, @label, @tags = expression, translation, label, tags
    end

    def data
      if @label.nil? && @tags.empty?
        {@expression => @translation}
      else
        data = {expression: @expression, translation: @translation}
        data.merge!(label: @label) if @label
        data.merge!(tags: @tags) unless @tags.empty?
        data
      end
    end
  end

  # # flashcard.variants
  # class Variant
  #   def initialize(prompt, correct_answer)
  #     @prompt, @correct_answer = prompt, correct_answer
  #   end
  #
  #   def mark(answer)
  #     answer == @correct_answer
  #   end
  #
  #   def new?
  #   end
  #
  #   def time_to_review?
  #   end
  # end

  class Flashcard
    attr_reader :data
    def initialize(data)
      @data = data
      @data[:metadata] ||= Hash.new

      deserialise_singular_or_plural_key(:example, data)
      self.examples.map! do |hash_or_example|
        if hash_or_example.is_a?(Example)
          hash_or_example
        elsif hash_or_example.keys.length == 1
          expression  = hash_or_example.keys.first
          translation = hash_or_example.values.first
          Example.new(expression: expression, translation: translation)
        else
          Example.new(**hash_or_example)
        end
      end

      deserialise_singular_or_plural_key(:tag, data)
      @data[:conjugations] ||= Hash.new if self.tags.include?(:verb)

      deserialise_singular_or_plural_key(:expression, data)
      if self.expressions.empty?
        raise ArgumentError.new('At least one expression has to be provided!')
      end

      deserialise_singular_or_plural_key(:translation, data)
      if self.translations.empty?
        raise ArgumentError.new('Translations has to be provided!')
      end

      deserialise_singular_or_plural_key(:silent_translation, data)
    end

    ATTRIBUTES = [
      :expressions, :translations, :silent_translations, :note, :hint, :tags, :conjugations, :examples, :metadata
    ]

    ATTRIBUTES.each do |attribute|
      define_method(attribute) { @data[attribute] }
    end

    def data
      @data.dup.tap do |data|
        serialise_singular_or_plural_key(:tag, data)
        self.examples.map!(&:data)
        serialise_singular_or_plural_key(:example, data)
        serialise_singular_or_plural_key(:expression, data)
        serialise_singular_or_plural_key(:translation, data)
        serialise_singular_or_plural_key(:silent_translation, data)

        data.delete(:tags) if tags.empty?
        data.delete(:examples) if examples.empty?
        data.delete(:conjugations) if conjugations && conjugations.empty?

        correct_answers = self.correct_answers.reduce(Hash.new) do |hash, (key, values)|
          hash.merge!(key => values) unless values.empty?
          hash
        end

        if correct_answers.keys == [:default]
          correct_answers = data[:metadata][:correct_answers] = correct_answers[:default]
        end

        data[:metadata].delete(:correct_answers) if correct_answers.empty?

        data.delete(:metadata) if metadata.empty?
      end
    end

    def ==(anotherFlashcard)
      self.expressions.sort == anotherFlashcard.expressions.sort && self.translations.sort == anotherFlashcard.translations.sort
    end

    def correct_answers
      if self.metadata[:correct_answers].is_a?(Array)
        self.metadata[:correct_answers] = {default: self.metadata[:correct_answers]}
      else
        (self.metadata[:correct_answers] ||= Hash.new).tap do |correct_answers|
          correct_answers.default_proc = Proc.new do |hash, key|
            hash[key] = Array.new
          end
        end
      end
    end

    def new?(key = nil)
      key = self.variants.first if self.variants.length == 1

      if key
        self.correct_answers[key].empty?
      else
        self.variants.any? do |key|
          self.new?(key)
        end
      end
    end

    def schedule
      Flashcards.app.config.schedule
    end

    def verb
      if self.tags.include?(:verb)
        Flashcards.app.language.verb(self.expressions.first, self.conjugations || Hash.new)
      end
    end

    def variants
      if self.verb
        [:default] + Flashcards.app.language.conjugation_groups
      else
        [:default]
      end
    end

    def time_to_review?(key = nil)
      key = self.variants.first if self.variants.length == 1

      if key
        return false if self.new?(key)

        number_of_days = self.schedule[self.correct_answers[key].length - 1] || (365 * 2)

        tolerance = (5 * 60 * 60) # 5 hours.
        self.correct_answers[key].last < (Time.now - ((number_of_days * 24 * 60 * 60) - tolerance))
      else
        self.variants.any? do |key|
          self.time_to_review?(key)
        end
      end
    end

    def should_run?(key = nil)
      self.new?(key) || self.time_to_review?(key)
    end

    def mark(answer, key = :default)
      if self.translations.include?(answer) || self.silent_translations.include?(answer)
        self.mark_as_correct(key)
      else
        self.mark_as_failed(key)
      end
    end

    def mark_as_failed(key = :default)
      self.correct_answers.delete(key) # Treat as new.
      return false
    end

    def mark_as_correct(key = :default)
      self.metadata[:correct_answers][key].push(Time.now)
      return true
    end

    protected
    def deserialise_singular_or_plural_key(key, data)
      if value = data.delete(key)
        data["#{key}s".to_sym] = [value].flatten
      elsif data["#{key}s".to_sym].is_a?(String)
        data["#{key}s".to_sym] = [data["#{key}s".to_sym]]
      elsif data["#{key}s".to_sym].is_a?(Array)
        # Already in the correct form.
      else
        data["#{key}s".to_sym] = Array.new
      end

      data["#{key}s".to_sym].map! do |value|
        value.is_a?(Integer) ? value.to_s : value
      end
    end

    def serialise_singular_or_plural_key(key, data)
      if data["#{key}s".to_sym].length == 1
        data[key] = data["#{key}s".to_sym][0]
        data.delete("#{key}s".to_sym)
      elsif data["#{key}s".to_sym].empty?
        data.delete("#{key}s".to_sym)
      end
    end
  end
end
