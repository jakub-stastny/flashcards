require 'flashcards'
require 'flashcards/language'

describe 'Gerundio' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.verb('hablar') }

    it 'is regular' do
      expect(hablar.gerundio.to_s).to eql('hablando')
    end
  end

  describe 'verbs ending with -er and -ir' do
    let(:comer) { spanish.verb('comer') }
    let(:vivir) { spanish.verb('vivir') }

    it 'is regular' do
      expect(comer.gerundio.to_s).to eql('comiendo')
      expect(vivir.gerundio.to_s).to eql('viviendo')
    end
  end

  # TODO: exceptions.
end
