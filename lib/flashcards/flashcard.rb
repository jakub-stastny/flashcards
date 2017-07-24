require 'flashcards' # FIXME: Extract Flashcards.app to flashcards/app.rb and change this.
require 'flashcards/testable_unit'
require 'digest/md5'

module Flashcards
  class Example
    attr_reader :expression, :translation, :label, :tags
    def initialize(expression:, translation:, label: nil, tags: Array.new)
      @expression, @translation, @label, @tags = expression, translation, label, tags.uniq
    end

    def data
      if @label.nil? && @tags.empty?
        {@expression => @translation}
      else
        data = {expression: @expression, translation: @translation}
        data.merge!(label: @label) if @label
        data.merge!(tags: @tags.uniq) unless @tags.empty?
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

  class Flashcard < TestableUnit
    def self.data_file_path(language_name)
      "~/Dropbox/Data/Data/Flashcards/#{language_name}.yml"
    end

    def initialize(data)
      super(data)

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

    def verb
      if self.tags.include?(:verb)
        Flashcards.app.language._verb(self.expressions.first, self.conjugations || Hash.new)
      end
    end

    def verify
      if self.verb && (checksum = self.metadata[:checksum])
        return Digest::MD5.hexdigest(self.verb.forms.to_yaml) == checksum
      elsif self.verb && self.metadata[:checksum].nil?
        # nil
      else
        true
      end
    end

    def set_checksum
      self.metadata[:checksum] = Digest::MD5.hexdigest(self.verb.forms.to_yaml)
    end

    def verified? # Verified against a dictionary.
      !! self.metadata[:checksum]
    end

    def variants
      if self.verb
        super + Flashcards.app.language.conjugation_groups
      else
        super
      end
    end

    def should_run?(key = nil)
      if (key && Flashcards.app.config.should_be_tested_on?(key)) || key.nil?
        super(key)
      end
    end

    def word_variants # TODO: nouns (plurals), cómodo/cómoda
      if self.tags.include?(:verb)
        self.expressions.map { |expression|
          Flashcards.app.language.conjugation_groups.map do |conjugation_group|
            self.verb.send(conjugation_group).forms.values + [expression] # Don't forget the infinitive.
          end
        }.flatten.uniq
      else
        self.expressions
      end
    end

    def mark(answer, key = :default)
      super(answer, key) do
        self.translations.include?(answer) ||
        self.silent_translations.include?(answer) ||
        self.expressions.include?(answer) ###
      end
    end
  end
end
