require 'flashcards'
require 'flashcards/language'

describe 'Participio' do
  let(:spanish) { Flashcards::App.new(:es).language }

  before do
    Flashcards::App.new(:es).language.flashcards = [
      Flashcards::Flashcard.new(expressions: ['hablar', 'hablarse'], translation: 'to speak', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['comer', 'comerse'], translation: 'to eat', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['vivir', 'vivirse'], translation: 'to live', tags: [:verb])
    ]
  end

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.load_verb('hablar') }

    it 'is regular' do
      expect(hablar.participio.regular?).to be(true)
      expect(hablar.participio.default).to eql('hablado')
    end
  end

  describe 'verbs ending with -er and -ir' do
    let(:comer) { spanish.load_verb('comer') }
    let(:vivir) { spanish.load_verb('vivir') }

    it 'is regular' do
      expect(comer.participio.regular?).to be(true)
      expect(vivir.participio.regular?).to be(true)

      expect(comer.participio.default).to eql('comido')
      expect(vivir.participio.default).to eql('vivido')
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.load_verb('hablarse').participio.default).to eql(spanish.load_verb('hablar').participio.default)
    expect(spanish.load_verb('comerse').participio.default).to eql(spanish.load_verb('comer').participio.default)
    expect(spanish.load_verb('vivirse').participio.default).to eql(spanish.load_verb('vivir').participio.default)
  end

  # TODO: How about ir? What's the stem of voy?
end
