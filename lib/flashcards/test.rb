require 'flashcards/testable_unit'

module Flashcards
  class Test < TestableUnit
    ATTRIBUTES = [:prompt, :options, :answer]

    ATTRIBUTES.each do |attribute|
      define_method(attribute) { @data[attribute] }
    end
  end
end
