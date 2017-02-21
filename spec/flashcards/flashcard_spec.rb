require 'spec_helper'
require 'flashcards/flashcard'

describe Flashcard do
  let(:required_arguments) do
    {expression: 'hola', translation: 'hi'}
  end

  describe '.new' do
    it 'requires expression' do
      expect {
        described_class.new(required_arguments.except(:expression))
      }.to raise_error(ArgumentError)
    end

    it 'requires translation' do
      expect {
        described_class.new(required_arguments.except(:translation))
      }.to raise_error(ArgumentError)
    end
  end

  subject do
    described_class.new()
  end
end
