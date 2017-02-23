require 'flashcards/config'

describe Flashcards::Config do
  subject do
    described_class.new('spec/data/flashcards.yml')
  end

  describe '.new' do
    it 'initialises with path as the only argument' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#data' do
    it 'loads the config' do
      expect(subject.data).to eql({'learning' => {'es' => ['present', 'past', 'reflective']}})
    end
  end

  describe '#language' do
    context 'with no arguments' do
      it 'returns the language if there is only one' do
        expect(subject.language.name).to eql(:es)
        expect(subject.language.tested_forms).to eql(['present', 'past', 'reflective'])
      end

      it 'raises an exception if there is more than one language configured' do
        subject = described_class.new('spec/data/flashcards_multiple.yml')
        expect { subject.language }.to raise_error
      end
    end

    context 'with the language as the first and only argument' do
      it 'returns the language there is such language configured' do
        expect(subject.language(:es).name).to eql(:es)
        expect(subject.language(:es).tested_forms).to eql(['present', 'past', 'reflective'])
      end

      it 'raises an exception if there is no such language configured' do
        expect { subject.language(:ru) }.to raise_error
      end
    end
  end
end
