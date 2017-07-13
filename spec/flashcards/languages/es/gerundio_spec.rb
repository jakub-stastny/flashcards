require 'flashcards'
require 'flashcards/language'

describe 'Gerundio' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.verb('hablar') }

    it 'is regular' do
      expect(hablar.gerundio.regular?).to be(true)
      expect(hablar.gerundio.default).to eql('hablando')
    end
  end

  describe 'verbs ending with -er and -ir' do
    let(:comer) { spanish.verb('comer') }
    let(:vivir) { spanish.verb('vivir') }

    it 'is regular' do
      expect(comer.gerundio.regular?).to be(true)
      expect(vivir.gerundio.regular?).to be(true)

      expect(comer.gerundio.default).to eql('comiendo')
      expect(vivir.gerundio.default).to eql('viviendo')
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.verb('hablarse').gerundio.default).to eql(spanish.verb('hablar').gerundio.default)
    expect(spanish.verb('comerse').gerundio.default).to eql(spanish.verb('comer').gerundio.default)
    expect(spanish.verb('vivirse').gerundio.default).to eql(spanish.verb('vivir').gerundio.default)
  end

  # TODO: How about ir? What's the stem of voy?
end
