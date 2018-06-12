# frozen_string_literal: true

require 'spec_helper'
require 'flashcards/flashcard'
require 'flashcards/core_exts'

describe Flashcards::Flashcard do
  using Flashcards::CoreExts

  let(:required_arguments) do
    {expression: 'hola', translations: ['hi', 'hello']}
  end

  describe '.new' do
    it 'requires expression' do
      expect {
        described_class.new(required_arguments.except(:expression))
      }.to raise_error(ArgumentError)
    end

    it 'requires translations' do
      expect {
        described_class.new(required_arguments.except(:translations))
      }.to raise_error(ArgumentError)
    end

    it 'initilises successfully with expression and translations' do
      expect {
        described_class.new(required_arguments)
      }.not_to raise_error
    end

    it 'also initilises successfully with expression and one translation' do
      expect {
        arguments = required_arguments.except(:translations)
        arguments[:translation] = 'a translation'
        described_class.new(arguments)
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
      expect(subject.data).to eql(expression: 'hola', translations: ['hi', 'hello'])
    end
  end

  describe '#==' do
    it 'returns true if the expression and the translations matches' do
      expect(subject == described_class.new(required_arguments)).to be(true)
    end

    it 'returns false if the expression does not match' do
      arguements = required_arguments.merge(expression: 'random_expression')
      expect(subject == described_class.new(arguements)).to be(false)
    end

    it 'returns false if the translations does not match' do
      arguements = required_arguments.merge(translations: ['random_translations'])
      expect(subject == described_class.new(arguements)).to be(false)
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

    context 'with an incorrect answer' do
      it 'returns false' do
        expect(subject.mark('co ja vim vole')).to be(false)
      end

      it 'resets the correct_answers' do
        # 1. Varianta 1.
        subject.metadata[:correct_answers] = [Time.now]
        expect { subject.mark('co ja vim vole') }.to change { subject.correct_answers }.to be_empty

        # 2. Varianta 2. Test with multiple keys.
        subject.metadata[:correct_answers] = {default: [Time.now]}
        expect { subject.mark('co ja vim vole') }.to change { subject.correct_answers }.to be_empty
      end
    end
  end
end
