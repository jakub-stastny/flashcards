require 'flashcards/language'

describe Flashcards::Language do
  subject { described_class.new(:cz, default: true) }

  describe '.new' do
    it 'requires name of the language and config' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#conjugation_group and #verb' do
    it 'conjugates the verb' do
      subject.conjugation_group(:přací) do |infinitive|
        Flashcards::Tense.new(:přací, infinitive) do
          case infinitive
          when /^(.+)at$/
            [$1, {já: 'al'}]
          end
        end
      end

      expect(subject.verb('šukat').přací.já).to eql('šukal')
    end
  end
end

describe Flashcards::Verb do
end

# TODO: ConjugationGroup?
describe Flashcards::Tense do
end
