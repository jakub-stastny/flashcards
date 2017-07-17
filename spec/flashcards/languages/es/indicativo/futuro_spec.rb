require 'flashcards'
require 'flashcards/language'

describe 'Futuro' do
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
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.futuro.infinitive).to eql('hablar')
      # expect(hablar.futuro.stem).to eql('habl')

      expect(hablar.futuro.irregular?(:yo)).to be(false)
      expect(hablar.futuro.irregular?(:tú)).to be(false)
      expect(hablar.futuro.irregular?(:vos)).to be(false)
      expect(hablar.futuro.irregular?(:él)).to be(false)
      expect(hablar.futuro.irregular?(:ella)).to be(false)
      expect(hablar.futuro.irregular?(:usted)).to be(false)
      expect(hablar.futuro.irregular?(:nosotros)).to be(false)
      expect(hablar.futuro.irregular?(:nosotras)).to be(false)
      expect(hablar.futuro.irregular?(:vosotros)).to be(false)
      expect(hablar.futuro.irregular?(:vosotras)).to be(false)
      expect(hablar.futuro.irregular?(:ellos)).to be(false)
      expect(hablar.futuro.irregular?(:ellas)).to be(false)
      expect(hablar.futuro.irregular?(:ustedes)).to be(false)

      expect(hablar.futuro.yo).to eql('hablaré')
      expect(hablar.futuro.tú).to eql('hablarás')
      expect(hablar.futuro.vos).to eql(hablar.futuro.tú)
      expect(hablar.futuro.él).to eql('hablará')
      expect(hablar.futuro.ella).to eql(hablar.futuro.él)
      expect(hablar.futuro.usted).to eql(hablar.futuro.él)

      expect(hablar.futuro.nosotros).to eql('hablaremos')
      expect(hablar.futuro.nosotras).to eql(hablar.futuro.nosotros)
      expect(hablar.futuro.vosotros).to eql('hablaréis')
      expect(hablar.futuro.vosotras).to eql(hablar.futuro.vosotros)
      expect(hablar.futuro.ellos).to eql('hablarán')
      expect(hablar.futuro.ellas).to eql(hablar.futuro.ellos)
      expect(hablar.futuro.ustedes).to eql(hablar.futuro.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish._verb('comer', Hash.new) }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.futuro.infinitive).to eql('comer')
      # expect(comer.futuro.stem).to eql('com')

      expect(comer.futuro.irregular?(:yo)).to be(false)
      expect(comer.futuro.irregular?(:tú)).to be(false)
      expect(comer.futuro.irregular?(:vos)).to be(false)
      expect(comer.futuro.irregular?(:él)).to be(false)
      expect(comer.futuro.irregular?(:ella)).to be(false)
      expect(comer.futuro.irregular?(:usted)).to be(false)
      expect(comer.futuro.irregular?(:nosotros)).to be(false)
      expect(comer.futuro.irregular?(:nosotras)).to be(false)
      expect(comer.futuro.irregular?(:vosotros)).to be(false)
      expect(comer.futuro.irregular?(:vosotras)).to be(false)
      expect(comer.futuro.irregular?(:ellos)).to be(false)
      expect(comer.futuro.irregular?(:ellas)).to be(false)
      expect(comer.futuro.irregular?(:ustedes)).to be(false)

      expect(comer.futuro.yo).to eql('comeré')
      expect(comer.futuro.tú).to eql('comerás')
      expect(comer.futuro.vos).to eql(comer.futuro.tú)
      expect(comer.futuro.él).to eql('comerá')
      expect(comer.futuro.ella).to eql(comer.futuro.él)
      expect(comer.futuro.usted).to eql(comer.futuro.él)

      expect(comer.futuro.nosotros).to eql('comeremos')
      expect(comer.futuro.nosotras).to eql(comer.futuro.nosotros)
      expect(comer.futuro.vosotros).to eql('comeréis')
      expect(comer.futuro.vosotras).to eql(comer.futuro.vosotros)
      expect(comer.futuro.ellos).to eql('comerán')
      expect(comer.futuro.ellas).to eql(comer.futuro.ellos)
      expect(comer.futuro.ustedes).to eql(comer.futuro.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish._verb('vivir', Hash.new) }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.futuro.infinitive).to eql('vivir')
      # expect(vivir.futuro.stem).to eql('viv')

      expect(vivir.futuro.irregular?(:yo)).to be(false)
      expect(vivir.futuro.irregular?(:tú)).to be(false)
      expect(vivir.futuro.irregular?(:vos)).to be(false)
      expect(vivir.futuro.irregular?(:él)).to be(false)
      expect(vivir.futuro.irregular?(:ella)).to be(false)
      expect(vivir.futuro.irregular?(:usted)).to be(false)
      expect(vivir.futuro.irregular?(:nosotros)).to be(false)
      expect(vivir.futuro.irregular?(:nosotras)).to be(false)
      expect(vivir.futuro.irregular?(:vosotros)).to be(false)
      expect(vivir.futuro.irregular?(:vosotras)).to be(false)
      expect(vivir.futuro.irregular?(:ellos)).to be(false)
      expect(vivir.futuro.irregular?(:ellas)).to be(false)
      expect(vivir.futuro.irregular?(:ustedes)).to be(false)

      expect(vivir.futuro.yo).to eql('viviré')
      expect(vivir.futuro.tú).to eql('vivirás')
      expect(vivir.futuro.vos).to eql(vivir.futuro.tú)
      expect(vivir.futuro.él).to eql('vivirá')
      expect(vivir.futuro.ella).to eql(vivir.futuro.él)
      expect(vivir.futuro.usted).to eql(vivir.futuro.él)

      expect(vivir.futuro.nosotros).to eql('viviremos')
      expect(vivir.futuro.nosotras).to eql(vivir.futuro.nosotros)
      expect(vivir.futuro.vosotros).to eql('viviréis')
      expect(vivir.futuro.vosotras).to eql(vivir.futuro.vosotros)
      expect(vivir.futuro.ellos).to eql('vivirán')
      expect(vivir.futuro.ellas).to eql(vivir.futuro.ellos)
      expect(vivir.futuro.ustedes).to eql(vivir.futuro.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse', Hash.new).futuro.él).to eql(spanish._verb('hablar', Hash.new).futuro.él)
    expect(spanish._verb('comerse', Hash.new).futuro.él).to eql(spanish._verb('comer', Hash.new).futuro.él)
    expect(spanish._verb('vivirse', Hash.new).futuro.él).to eql(spanish._verb('vivir', Hash.new).futuro.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
