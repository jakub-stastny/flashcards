require 'flashcards/testable_unit'

module Flashcards
  class Test < TestableUnit
    def self.data_file_path(language_name)
      "~/Dropbox/Data/Data/Flashcards/#{language_name}.tests.yml"
    end

    ATTRIBUTES = [:prompt, :options, :answer, :metadata]

    ATTRIBUTES.each do |attribute|
      define_method(attribute) { @data[attribute] }
    end

    def options
      @data[:options] || Array.new
    end

    def mark(answer)
      super(answer) do
        if answer.match(/^\d+$/) && ! self.options.empty?
          answer = self.options[answer.to_i - 1]
        end

        self.answer == answer
      end
    end
  end
end
