require 'flashcards'
require 'flashcards/language'

describe 'Participio' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.verb('hablar') }

    it 'is regular' do
      expect(hablar.participio.to_s).to eql('hablado')
    end
  end

  describe 'verbs ending with -er and -ir' do
    let(:comer) { spanish.verb('comer') }
    let(:vivir) { spanish.verb('vivir') }

    it 'is regular' do
      expect(comer.participio.to_s).to eql('comido')
      expect(vivir.participio.to_s).to eql('vivido')
    end
  end

  # TODO: exceptions.
end
