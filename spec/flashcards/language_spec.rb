# frozen_string_literal: true

require 'flashcards/language'

describe Flashcards::Language do
  subject { described_class.new(:cz) }

  describe '.new' do
    it 'requires name of the language and config' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#conjugation_group and #verb' do
    it 'conjugates the verb' do
      pending "Make deaccentuation language-specific thing."
      subject.conjugation_group(:přací) do |verb, infinitive|
        Flashcards::Tense.new(subject, :přací, infinitive) do
          case infinitive
          when /^(.+)at$/
            [$1, {já: 'al bych'}]
          end
        end
      end

      expect(subject._verb('šukat', Hash.new).přací.já).to eql('šukal bych')
    end
  end
end

describe Flashcards::Verb do
end

# TODO: ConjugationGroup?
describe Flashcards::Tense do
end
