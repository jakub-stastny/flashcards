require 'flashcards/flashcard_wrapper'
require 'flashcards/example'
require 'flashcards/testable_unit'
require 'flashcards/core_exts'
require 'digest/md5'

module Flashcards
  # # flashcard.with(app).variants
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
    using CoreExts

    def initialize(data)
      super(data)

      deserialise_singular_or_plural_key(:example, data)
      self.examples.map! do |hash_string_or_example|
        if hash_string_or_example.is_a?(Example)
          hash_string_or_example
        elsif hash_string_or_example.is_a?(String)
          Example.new(expression: hash_string_or_example, translation: nil)
        elsif hash_string_or_example.keys.length == 1
          expression  = hash_string_or_example.keys.first
          translation = hash_string_or_example.values.first
          Example.new(expression: expression, translation: translation)
        else
          if hash_string_or_example[:tag]
            tag = hash_string_or_example.delete(:tag)
            hash_string_or_example[:tags] = [tag]
          end

          Example.new(**hash_string_or_example)
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

      deserialise_singular_or_plural_key(:note, data)
    end

    ATTRIBUTES = [
      :expressions, :translations, :silent_translations, :notes, :hint, :tags, :conjugations, :examples, :metadata, :_
    ]

    ATTRIBUTES.each do |attribute|
      define_method(attribute) { @data[attribute] }
    end

    def last_review_time
      self.metadata[:last_review_time]
    end

    def expanded_data
      results = Hash.new
      results[:expressions] = self.expressions.dup
      results[:translations] = self.translations.dup
      results[:silent_translations] = self.silent_translations.dup
      results[:tags]  = self.tags.dup
      if self.notes.length <= 2 # Empty or 1.
        results[:note] = self.notes.dup
      else
        results[:notes] = self.notes.dup
      end
      results[:hint]  = self.hint.dup
      results[:examples] = self.examples.map(&:expanded_data)
      results[:conjugations] = self.conjugations.dup if self.tags.include?(:verb)
      results[:_] = self._.dup
      results[:metadata] = self.data[:metadata].dup
      results
    end

    def data
      results = Hash.new # This is to avoid #deep_copy issues.
      # Hash#deep_copy wouldn't call Array#deep_copy within the same refinement
      # module and Array#deep_copy from refinements wouldn't go very deep on
      # nested array either.
      #
      # This approach has the disadvantage that any new attribute has to be added
      # here, lest they get lost.
      #
      # On the plus side, we're able to determine order of the keys, as it seems.

      serialise_singular_or_plural_key(:expression, @data, results)
      serialise_singular_or_plural_key(:translation, @data, results)
      serialise_singular_or_plural_key(:silent_translation, @data, results)
      serialise_singular_or_plural_key(:tag, @data, results)
      serialise_singular_or_plural_key(:note, @data, results) unless self.notes.empty?
      results[:hint] = self.hint if self.hint
      serialise_singular_or_plural_key(:example, {examples: self.examples.map(&:data)}, results)

      unless self.conjugations.nil? || self.conjugations.empty?
        results[:conjugations] = self.conjugations.dup
      end

      results[:_] = self._.dup if self._

      results[:metadata] = self.metadata.dup

      if self.correct_answers.empty? || self.correct_answers == {default: Array.new}
        results[:metadata].delete(:correct_answers)
      else
        correct_answers = self.correct_answers.reduce(Hash.new) do |hash, (key, values)|
          hash.merge!(key => values) unless values.empty?
          hash
        end

        if correct_answers.keys == [:default]
          correct_answers = correct_answers[:default]
        end

        results[:metadata][:correct_answers] = correct_answers
      end

      results.delete(:metadata) if results[:metadata].empty?

      results
    end

    def to_s
      "<yellow>#{self.expressions.join(',')}</yellow> (<green>#{self.translations.join(',')}</green>)"
    end

    def ==(anotherFlashcard)
      self.expressions.sort == anotherFlashcard.expressions.sort && self.translations.sort == anotherFlashcard.translations.sort
    end

    def verified? # Verified against a dictionary.
      !! self.metadata[:checksum]
    end

    def with(app)
      @wrapped_flashcard ||= FlashcardWrapper.new(app, self)
    end

    def mark(answer, key = :default)
      super(answer, key) do
        self.translations.include?(answer) ||
        self.silent_translations.include?(answer) ||
        self.expressions.include?(answer) ###
      end
    end

    def unknown_attributes
      self.data.keys.reject do |key|
        ATTRIBUTES.include?(key) || ATTRIBUTES.include?("#{key}s".to_sym)
      end
    end
  end
end
