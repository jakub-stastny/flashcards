require 'flashcards'
require 'flashcards/language'

describe 'Formal commands' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.verb('hablar') }

    it 'is regular' do
      expect(hablar.imperativo_formal.exception?(:usted)).to be(false)
      expect(hablar.imperativo_formal.exception?(:ustedes)).to be(false)

      expect(hablar.imperativo_formal.usted).to eql('hable')
      expect(hablar.imperativo_formal.ustedes).to eql('hablen')
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.verb('comer') }

    it 'is regular' do
      expect(comer.imperativo_formal.exception?(:usted)).to be(false)
      expect(comer.imperativo_formal.exception?(:ustedes)).to be(false)

      expect(comer.imperativo_formal.usted).to eql('coma')
      expect(comer.imperativo_formal.ustedes).to eql('coman')
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.verb('vivir') }

    it 'is regular' do
      expect(vivir.imperativo_formal.exception?(:usted)).to be(false)
      expect(vivir.imperativo_formal.exception?(:ustedes)).to be(false)

      expect(vivir.imperativo_formal.usted).to eql('viva')
      expect(vivir.imperativo_formal.ustedes).to eql('vivan')
    end
  end
end
