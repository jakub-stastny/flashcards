# frozen_string_literal: true

require 'spec_helper'
require 'flashcards' # app
require 'flashcards/flashcard_wrapper'

describe Flashcards::FlashcardWrapper do
  let(:app)       { Flashcards::App.new(:es) }
  let(:flashcard) { Flashcards::Flashcard.new(expressions: ['a'], translations: ['b']) }

  subject do
    described_class.new(app, flashcard)
  end

  describe '#new?' do
    it 'is false if there are any correct answers' do
      flashcard.metadata[:correct_answers] = Array.new
      3.times { flashcard.metadata[:correct_answers] << Time.now }
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
        flashcard.metadata[:correct_answers] = [Time.now - (5 * 60 * 60)]
        expect(subject).not_to be_time_to_review
      end

      it 'is true if the answer is more than 24 hours old' do
        flashcard.metadata[:correct_answers] = [Time.now - (25 * 60 * 60)]
        expect(subject).to be_time_to_review
      end
    end

    context 'with two correct answers' do
      let(:three_days_ago) { Time.now - (3 * 24 * 60 * 60) }
      let(:six_days_ago) { Time.now - (6 * 24 * 60 * 60) }
      let(:ten_days_ago) { Time.now - (10 * 24 * 60 * 60) }

      it 'is false if the last answer is less than 5 days old' do
        flashcard.metadata[:correct_answers] = [ten_days_ago, three_days_ago]
        expect(subject).not_to be_time_to_review
      end

      it 'is true if the last answer is more than 5 days old' do
        flashcard.metadata[:correct_answers] = [ten_days_ago, six_days_ago]
        expect(subject).to be_time_to_review
      end
    end

    context 'with three correct answers' do
      let(:three_days_ago) { Time.now - (3 * 24 * 60 * 60) }
      let(:twenty_six_days_ago) { Time.now - (6 * 24 * 60 * 60) }
      let(:thirty_days_ago) { Time.now - (30 * 24 * 60 * 60) }

      it 'is false if the last answer is less than 25 days old' do
        flashcard.metadata[:correct_answers] = [twenty_six_days_ago, three_days_ago]
        expect(subject).not_to be_time_to_review
      end

      it 'is true if the last answer is more than 25 days old' do
        flashcard.metadata[:correct_answers] = [thirty_days_ago, twenty_six_days_ago]
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
end
