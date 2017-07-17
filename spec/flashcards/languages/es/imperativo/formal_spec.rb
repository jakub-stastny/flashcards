require 'flashcards'
require 'flashcards/language'

describe 'Formal commands' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish._verb('hablar', Hash.new) }

    it 'is regular' do
      expect(hablar.imperativo_formal.irregular?(:usted)).to be(false)
      expect(hablar.imperativo_formal.irregular?(:ustedes)).to be(false)

      expect(hablar.imperativo_formal.usted).to eql('hable')
      expect(hablar.imperativo_formal.ustedes).to eql('hablen')
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish._verb('comer', Hash.new) }

    it 'is regular' do
      expect(comer.imperativo_formal.irregular?(:usted)).to be(false)
      expect(comer.imperativo_formal.irregular?(:ustedes)).to be(false)

      expect(comer.imperativo_formal.usted).to eql('coma')
      expect(comer.imperativo_formal.ustedes).to eql('coman')
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish._verb('vivir', Hash.new) }

    it 'is regular' do
      expect(vivir.imperativo_formal.irregular?(:usted)).to be(false)
      expect(vivir.imperativo_formal.irregular?(:ustedes)).to be(false)

      expect(vivir.imperativo_formal.usted).to eql('viva')
      expect(vivir.imperativo_formal.ustedes).to eql('vivan')
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse', Hash.new).imperativo_formal.usted).to eql(spanish._verb('hablar', Hash.new).imperativo_formal.usted)
    expect(spanish._verb('comerse', Hash.new).imperativo_formal.usted).to eql(spanish._verb('comer', Hash.new).imperativo_formal.usted)
    expect(spanish._verb('vivirse', Hash.new).imperativo_formal.usted).to eql(spanish._verb('vivir', Hash.new).imperativo_formal.usted)
  end

  # TODO: How about ir? What's the stem of voy?
end
