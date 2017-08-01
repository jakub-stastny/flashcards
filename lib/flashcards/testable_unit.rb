require 'yaml'
require 'pathname'
require 'flashcards/flashcard_wrapper'

module Flashcards
  class TestableUnit
    attr_reader :data
    def initialize(data)
      @data = data
      @data[:metadata] ||= Hash.new
    end

    def to_yaml # Array#to_yaml would ignore this, fortunately our custom collection deals with it.
      self.data.to_yaml
    end

    def mark(answer, key = :default, &block)
      if block.call
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
      self.correct_answers[key].push(Time.now)
      return true
    end

    def correct_answers
      if self.metadata[:correct_answers].is_a?(Array)
        hash = self.metadata[:correct_answers] = {default: self.metadata[:correct_answers]}
      else
        hash = self.metadata[:correct_answers] ||= Hash.new
      end

      hash.tap do |correct_answers|
        correct_answers.default_proc = Proc.new do |hash, key|
          hash[key] = Array.new
        end
      end
    end

    def with(app)
      @wrapped_flashcard ||= TestableUnitWrapper.new(app, self)
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

    def serialise_singular_or_plural_key(key, data, results)
      collection = data["#{key}s".to_sym] || data[key.to_sym]
      return unless collection

      collection.uniq! # The only modifying change.

      if collection.length == 1
        results[key] = collection[0]
      elsif collection.empty?
        # void
      elsif collection.length > 1
        results["#{key}s".to_sym] = collection
      end
    end
  end
end
