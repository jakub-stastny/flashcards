require 'spec_helper'
require 'flashcards/flashcard'

describe Flashcard do
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

  describe '#new?' do
    it 'is false if there are any correct answers' do
      subject.metadata[:correct_answers] = Array.new
      3.times { subject.metadata[:correct_answers] << Time.now }
      expect(subject).not_to be_new
    end

    it 'is true if there are no correct answers' do
      expect(subject).to be_new
    end
  end

  # TODO: Test tolerance.
  describe '#time_to_review?' do
    context 'with one correct answer' do
      it 'is false if the answer is less than 24 hours old' do
        subject.metadata[:correct_answers] = [Time.now - (5 * 60 * 60)]
        expect(subject).not_to be_time_to_review
      end

      it 'is true if the answer is more than 24 hours old' do
        subject.metadata[:correct_answers] = [Time.now - (25 * 60 * 60)]
        expect(subject).to be_time_to_review
      end
    end

    context 'with two correct answers' do
      let(:three_days_ago) { Time.now - (3 * 24 * 60 * 60) }
      let(:six_days_ago) { Time.now - (6 * 24 * 60 * 60) }
      let(:ten_days_ago) { Time.now - (10 * 24 * 60 * 60) }

      it 'is false if the last answer is less than 5 days old' do
        subject.metadata[:correct_answers] = [ten_days_ago, three_days_ago]
        expect(subject).not_to be_time_to_review
      end

      it 'is true if the last answer is more than 5 days old' do
        subject.metadata[:correct_answers] = [ten_days_ago, six_days_ago]
        expect(subject).to be_time_to_review
      end
    end

    context 'with three correct answers' do
      let(:three_days_ago) { Time.now - (3 * 24 * 60 * 60) }
      let(:twenty_six_days_ago) { Time.now - (6 * 24 * 60 * 60) }
      let(:thirty_days_ago) { Time.now - (30 * 24 * 60 * 60) }

      it 'is false if the last answer is less than 25 days old' do
        subject.metadata[:correct_answers] = [twenty_six_days_ago, three_days_ago]
        expect(subject).not_to be_time_to_review
      end

      it 'is true if the last answer is more than 25 days old' do
        subject.metadata[:correct_answers] = [thirty_days_ago, twenty_six_days_ago]
        expect(subject).to be_time_to_review
      end
    end

    context 'with four correct answers' do
      pending 'TODO: Review in 3 months.'
    end

    context 'with five correct answers' do
      pending 'TODO: Review in 2 years'
    end

    context 'with more than five correct answers' do
      pending 'TODO: Review in 2 years'
    end

    it 'is false if there are no correct answers yet' do
      expect(subject).not_to be_time_to_review
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
        subject.metadata[:correct_answers] = [Time.now]
        expect { subject.mark('co ja vim vole') }.to change { subject.metadata[:correct_answers] }.to(nil)
      end
    end
  end
end
