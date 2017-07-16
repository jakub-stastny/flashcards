require 'flashcards'
require 'flashcards/language'

describe 'Participio' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish._verb('hablar') }

    it 'is regular' do
      expect(hablar.participio.regular?).to be(true)
      expect(hablar.participio.default).to eql('hablado')
    end
  end

  describe 'verbs ending with -er and -ir' do
    let(:comer) { spanish._verb('comer') }
    let(:vivir) { spanish._verb('vivir') }

    it 'is regular' do
      expect(comer.participio.regular?).to be(true)
      expect(vivir.participio.regular?).to be(true)

      expect(comer.participio.default).to eql('comido')
      expect(vivir.participio.default).to eql('vivido')
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse').participio.default).to eql(spanish._verb('hablar').participio.default)
    expect(spanish._verb('comerse').participio.default).to eql(spanish._verb('comer').participio.default)
    expect(spanish._verb('vivirse').participio.default).to eql(spanish._verb('vivir').participio.default)
  end

  # TODO: How about ir? What's the stem of voy?
end
