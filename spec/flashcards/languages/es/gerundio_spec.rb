require 'flashcards'
require 'flashcards/language'

describe 'Gerundio' do
  let(:spanish) { Flashcards.app.language }

  before do
    Flashcards.app.language.flashcards = [
      Flashcards::Flashcard.new(expressions: ['hablar', 'hablarse'], translation: 'to speak', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['comer', 'comerse'], translation: 'to eat', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['vivir', 'vivirse'], translation: 'to live', tags: [:verb])
    ]
  end

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.load_verb('hablar') }

    it 'is regular' do
      expect(hablar.gerundio.regular?).to be(true)
      expect(hablar.gerundio.default).to eql('hablando')
    end
  end

  describe 'verbs ending with -er and -ir' do
    let(:comer) { spanish.load_verb('comer') }
    let(:vivir) { spanish.load_verb('vivir') }

    it 'is regular' do
      expect(comer.gerundio.regular?).to be(true)
      expect(vivir.gerundio.regular?).to be(true)

      expect(comer.gerundio.default).to eql('comiendo')
      expect(vivir.gerundio.default).to eql('viviendo')
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.load_verb('hablarse').gerundio.default).to eql(spanish.load_verb('hablar').gerundio.default)
    expect(spanish.load_verb('comerse').gerundio.default).to eql(spanish.load_verb('comer').gerundio.default)
    expect(spanish.load_verb('vivirse').gerundio.default).to eql(spanish.load_verb('vivir').gerundio.default)
  end

  # TODO: How about ir? What's the stem of voy?
end
