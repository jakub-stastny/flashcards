require 'flashcards'
require 'flashcards/language'

describe 'Affirmative informal commands' do
  let(:spanish) { Flashcards::App.new(:es).language }

  before do
    Flashcards::App.new(:es).language.flashcards = [
      Flashcards::Flashcard.new(expressions: ['hablar', 'hablarse'], translation: 'to speak', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['comer', 'comerse'], translation: 'to eat', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['vivir', 'vivirse'], translation: 'to live', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['tener'], translation: 'to have', tags: [:verb], conjugations: {imperativo_positivo: {tú: 'ten'}})
    ]
  end

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.load_verb('hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.imperativo_positivo.infinitive).to eql('hablar')
      expect(hablar.imperativo_positivo.stem).to eql('habl')

      expect(hablar.imperativo_positivo.irregular?(:tú)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:vos)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:nosotros)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:nosotras)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:vosotros)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:vosotras)).to be(false)

      expect(hablar.imperativo_positivo.tú).to eql('habla')
      expect(hablar.imperativo_positivo.vos).to eql('hablá')

      expect(hablar.imperativo_positivo.nosotros).to eql('hablemos')
      expect(hablar.imperativo_positivo.nosotras).to eql(hablar.imperativo_positivo.nosotros)
      expect(hablar.imperativo_positivo.vosotros).to eql('hablad')
      expect(hablar.imperativo_positivo.vosotras).to eql(hablar.imperativo_positivo.vosotros)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.load_verb('comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.imperativo_positivo.infinitive).to eql('comer')
      expect(comer.imperativo_positivo.stem).to eql('com')

      expect(comer.imperativo_positivo.irregular?(:tú)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:vos)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:nosotros)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:nosotras)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:vosotros)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:vosotras)).to be(false)

      expect(comer.imperativo_positivo.tú).to eql('come')
      expect(comer.imperativo_positivo.vos).to eql('comé')

      expect(comer.imperativo_positivo.nosotros).to eql('comamos')
      expect(comer.imperativo_positivo.nosotras).to eql(comer.imperativo_positivo.nosotros)
      expect(comer.imperativo_positivo.vosotros).to eql('comed')
      expect(comer.imperativo_positivo.vosotras).to eql(comer.imperativo_positivo.vosotros)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.load_verb('vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.imperativo_positivo.infinitive).to eql('vivir')
      expect(vivir.imperativo_positivo.stem).to eql('viv')

      expect(vivir.imperativo_positivo.irregular?(:tú)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:vos)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:nosotros)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:nosotras)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:vosotros)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:vosotras)).to be(false)

      expect(vivir.imperativo_positivo.tú).to eql('vive')
      expect(vivir.imperativo_positivo.vos).to eql('viví')

      expect(vivir.imperativo_positivo.nosotros).to eql('vivamos')
      expect(vivir.imperativo_positivo.nosotras).to eql(vivir.imperativo_positivo.nosotros)
      expect(vivir.imperativo_positivo.vosotros).to eql('vivid')
      expect(vivir.imperativo_positivo.vosotras).to eql(vivir.imperativo_positivo.vosotros)
    end
  end

  describe 'irregular verbs' do
    let(:tener) { spanish.load_verb('tener') }

    it 'is irregular' do
      expect(tener.imperativo_positivo.irregular?(:tú)).to be(true)
      expect(tener.imperativo_positivo.tú).to eql('ten')
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.load_verb('hablarse').imperativo_positivo.tú).to eql(spanish.load_verb('hablar').imperativo_positivo.tú)
    expect(spanish.load_verb('comerse').imperativo_positivo.tú).to eql(spanish.load_verb('comer').imperativo_positivo.tú)
    expect(spanish.load_verb('vivirse').imperativo_positivo.tú).to eql(spanish.load_verb('vivir').imperativo_positivo.tú)
  end

  # TODO: How about ir? What's the stem of voy?
end
