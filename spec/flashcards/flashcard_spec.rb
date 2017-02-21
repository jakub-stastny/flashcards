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

    it 'initilises successfully with expression and translation' do
      expect {
        described_class.new(required_arguments)
      }.not_to raise_error
    end
  end

  subject do
    described_class.new(required_arguments)
  end

  describe '#metadata' do
    it 'is an empty hash by default' do
      expect(subject.metadata).to eql(Hash.new)
    end
  end

  describe '#examples' do
    it 'is an empty array by default' do
      expect(subject.examples).to eql(Array.new)
    end
  end

  describe '#data' do
    it 'returns all the data except empty metadata' do
      expect(subject.data).to eql(expression: 'hola', translation: 'hi', examples: [])
    end
  end

  describe '#==' do
    it 'returns true if the expression and the translation matches' do
      expect(subject == described_class.new(required_arguments)).to be(true)
    end

    it 'returns false if the expression does not match' do
      arguements = required_arguments.merge(expression: 'random_expression')
      expect(subject == described_class.new(arguements)).to be(false)
    end

    it 'returns false if the translation does not match' do
      arguements = required_arguments.merge(translation: 'random_translation')
      expect(subject == described_class.new(arguements)).to be(false)
    end
  end

  describe '#remembered?' do
    it 'is true if there are 3 or more correct answers' do
      subject.metadata[:correct_answers] ||= Array.new
      3.times { subject.metadata[:correct_answers] << Time.now }
      expect(subject).to be_remembered
    end

    it 'is false if there are less than 3 correct answers' do
      expect(subject).not_to be_remembered
    end
  end

  describe '#mark' do
    context 'with a correct answer' do
      it 'returns true' do
        expect(subject.mark('hi')).to be(true)
      end

      it 'pushes the current time into the correct_answers metadata' do
        subject.metadata[:correct_answers] ||= Array.new
        expect { subject.mark('hi') }.to change { subject.metadata[:correct_answers].length }.by(1)
      end
    end

    context 'with a correct answer' do
      it 'returns false' do
        expect(subject.mark('co ja vim vole')).to be(false)
      end

      it 'resets the correct_answers' do
        subject.metadata[:correct_answers] = [Time.now]
        expect { subject.mark('co ja vim vole') }.to change { subject.metadata[:correct_answers] }.to(nil)
      end
    end
  end
end
