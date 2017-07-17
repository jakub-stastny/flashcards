require 'flashcards'
require 'flashcards/language'

describe 'Participio' do
  let(:spanish) { Flashcards.app.language }

  before do
    Flashcards.app.language.flashcards = [
      Flashcards::Flashcard.new(expressions: ['hablar', 'hablarse'], translation: 'to speak', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['comer', 'comerse'], translation: 'to eat', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['vivir', 'vivirse'], translation: 'to live', tags: [:verb])
    ]
  end

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish._verb('hablar', Hash.new) }

    it 'is regular' do
      expect(hablar.participio.regular?).to be(true)
      expect(hablar.participio.default).to eql('hablado')
    end
  end

  describe 'verbs ending with -er and -ir' do
    let(:comer) { spanish._verb('comer', Hash.new) }
    let(:vivir) { spanish._verb('vivir', Hash.new) }

    it 'is regular' do
      expect(comer.participio.regular?).to be(true)
      expect(vivir.participio.regular?).to be(true)

      expect(comer.participio.default).to eql('comido')
      expect(vivir.participio.default).to eql('vivido')
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse', Hash.new).participio.default).to eql(spanish._verb('hablar', Hash.new).participio.default)
    expect(spanish._verb('comerse', Hash.new).participio.default).to eql(spanish._verb('comer', Hash.new).participio.default)
    expect(spanish._verb('vivirse', Hash.new).participio.default).to eql(spanish._verb('vivir', Hash.new).participio.default)
  end

  # TODO: How about ir? What's the stem of voy?
end
