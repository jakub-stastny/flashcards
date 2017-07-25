require 'flashcards' # FIXME: Extract Flashcards.app to flashcards/app.rb and change this.
require 'flashcards/example'
require 'flashcards/testable_unit'
require 'flashcards/core_exts'
require 'digest/md5'

module Flashcards
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
    using CoreExts

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

    attr_accessor :metadata
    ATTRIBUTES.each do |attribute|
      define_method(attribute) { @data[attribute] }
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
      results[:note] = self.note if self.note
      results[:hint] = self.hint if self.hint
      serialise_singular_or_plural_key(:example, {examples: self.examples.map(&:data)}, results)

      unless self.conjugations.nil? || self.conjugations.empty?
        results[:conjugations] = self.conjugations.dup
      end

      results[:metadata] = self.metadata.dup

      if self.correct_answers.empty?
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

    def unknown_attributes
      self.data.keys.reject do |key|
        ATTRIBUTES.include?(key) || ATTRIBUTES.include?("#{key}s".to_sym)
      end
    end
  end
end
