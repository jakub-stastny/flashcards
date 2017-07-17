require 'flashcards'
require 'flashcards/language'

describe 'Negative informal commands' do
  let(:spanish) { Flashcards.app.language }

  before do
    Flashcards.app.language.flashcards = [
      Flashcards::Flashcard.new(expressions: ['hablar', 'hablarse'], translation: 'to speak', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['comer', 'comerse'], translation: 'to eat', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['vivir', 'vivirse'], translation: 'to live', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['dar'], translation: 'to give', tags: [:verb], conjugations: {subjuntivo: {él: 'dé'}})
    ]
  end

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.load_verb('hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.imperativo_negativo.infinitive).to eql('hablar')
      expect(hablar.imperativo_negativo.stem).to eql('habl')

      expect(hablar.imperativo_negativo.irregular?(:tú)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:vos)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:nosotros)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:nosotras)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:vosotros)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:vosotras)).to be(false)

      expect(hablar.imperativo_negativo.tú).to eql('hables')
      expect(hablar.imperativo_negativo.vos).to eql(hablar.imperativo_negativo.tú) # Is it?

      expect(hablar.imperativo_negativo.nosotros).to eql('hablemos')
      expect(hablar.imperativo_negativo.nosotras).to eql(hablar.imperativo_negativo.nosotros)
      expect(hablar.imperativo_negativo.vosotros).to eql('habléis')
      expect(hablar.imperativo_negativo.vosotras).to eql(hablar.imperativo_negativo.vosotros)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.load_verb('comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.imperativo_negativo.infinitive).to eql('comer')
      expect(comer.imperativo_negativo.stem).to eql('com')

      expect(comer.imperativo_negativo.irregular?(:tú)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:vos)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:nosotros)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:nosotras)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:vosotros)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:vosotras)).to be(false)

      expect(comer.imperativo_negativo.tú).to eql('comas')
      expect(comer.imperativo_negativo.vos).to eql(comer.imperativo_negativo.tú) # Is it?

      expect(comer.imperativo_negativo.nosotros).to eql('comamos')
      expect(comer.imperativo_negativo.nosotras).to eql(comer.imperativo_negativo.nosotros)
      expect(comer.imperativo_negativo.vosotros).to eql('comáis')
      expect(comer.imperativo_negativo.vosotras).to eql(comer.imperativo_negativo.vosotros)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.load_verb('vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.imperativo_negativo.infinitive).to eql('vivir')
      expect(vivir.imperativo_negativo.stem).to eql('viv')

      expect(vivir.imperativo_negativo.irregular?(:tú)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:vos)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:nosotros)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:nosotras)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:vosotros)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:vosotras)).to be(false)

      expect(vivir.imperativo_negativo.tú).to eql('vivas')
      expect(vivir.imperativo_negativo.vos).to eql(vivir.imperativo_negativo.tú) # Is it?

      expect(vivir.imperativo_negativo.nosotros).to eql('vivamos')
      expect(vivir.imperativo_negativo.nosotras).to eql(vivir.imperativo_negativo.nosotros)
      expect(vivir.imperativo_negativo.vosotros).to eql('viváis')
      expect(vivir.imperativo_negativo.vosotras).to eql(vivir.imperativo_negativo.vosotros)
    end
  end

  # Is des a regular or an irregular form?
  describe 'verbs with an irregular subjunctive' do
    let(:dar) { spanish.load_verb('dar') }

    it 'is regular' do
      expect(dar.imperativo_negativo.tú).to eql('des')
      expect(dar.imperativo_negativo.vos).to eql(dar.imperativo_negativo.tú)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.load_verb('hablarse').imperativo_negativo.tú).to eql(spanish.load_verb('hablar').imperativo_negativo.tú)
    expect(spanish.load_verb('comerse').imperativo_negativo.tú).to eql(spanish.load_verb('comer').imperativo_negativo.tú)
    expect(spanish.load_verb('vivirse').imperativo_negativo.tú).to eql(spanish.load_verb('vivir').imperativo_negativo.tú)
  end

  # TODO: How about ir? What's the stem of voy?
end
