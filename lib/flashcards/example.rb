module Flashcards
  class Example
    def self.deserialise(array_string_or_example)
      if array_string_or_example.is_a?(self)
        array_string_or_example
      elsif array_string_or_example.is_a?(String)
        self.new(expression: array_string_or_example, translation: nil)
      elsif array_string_or_example.is_a?(Array)
        expression  = array_string_or_example[0]
        translation = array_string_or_example[1]
        label = array_string_or_example[2]
        tags = [array_string_or_example[3]].flatten
        self.new(expression: expression, translation: translation, label: label, tags: tags)
      elsif array_string_or_example.is_a?(Hash) && array_string_or_example.keys.length == 1
        # Older, but still valid syntax of :examples:\n-Expression.: Translation.
        expression = array_string_or_example.keys.first
        translation = array_string_or_example.values.first
        self.new(expression: expression, translation: translation)
      else
        raise "Should not occur."
      end
    end

    attr_reader :expression, :translation, :label, :tags
    def initialize(expression:, translation:, label: nil, tags: Array.new)
      tags = Array.new if tags.nil?
      @expression, @translation, @label, @tags = expression, translation, label, tags.compact.uniq
    end

    def expanded_data
      self.data
    end

    def data
      tags = @tags.compact.uniq

      Array.new.tap do |buffer|
        buffer[0] = @expression
        buffer[1] = @translation if @translation
        buffer[2] = @label if @label
        buffer[3] = tags unless tags.empty?
      end
    end
  end
end
