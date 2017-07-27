module Flashcards
  class Example
    attr_reader :expression, :translation, :label, :tags
    def initialize(expression:, translation:, label: nil, tags: Array.new)
      @expression, @translation, @label, @tags = expression, translation, label, tags.uniq
    end

    def expanded_data
      data = {expression: @expression, translation: @translation}
      data.merge!(label: @label) if @label
      data.merge!(tags: @tags.uniq) unless @tags.empty?
      data
    end

    def data
      if @label.nil? && @tags.empty?
        {@expression => @translation}
      else
        self.expanded_data
      end
    end
  end
end
