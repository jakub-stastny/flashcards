require 'flashcards'
require 'flashcards/language'

describe 'Condicional' do
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
      expect(hablar.condicional.infinitive).to eql('hablar')
      # expect(hablar.condicional.root).to eql('habl') # TODO: is it called root or stem?

      expect(hablar.condicional.irregular?(:yo)).to be(false)
      expect(hablar.condicional.irregular?(:tú)).to be(false)
      expect(hablar.condicional.irregular?(:vos)).to be(false)
      expect(hablar.condicional.irregular?(:él)).to be(false)
      expect(hablar.condicional.irregular?(:ella)).to be(false)
      expect(hablar.condicional.irregular?(:usted)).to be(false)
      expect(hablar.condicional.irregular?(:nosotros)).to be(false)
      expect(hablar.condicional.irregular?(:nosotras)).to be(false)
      expect(hablar.condicional.irregular?(:vosotros)).to be(false)
      expect(hablar.condicional.irregular?(:vosotras)).to be(false)
      expect(hablar.condicional.irregular?(:ellos)).to be(false)
      expect(hablar.condicional.irregular?(:ellas)).to be(false)
      expect(hablar.condicional.irregular?(:ustedes)).to be(false)

      expect(hablar.condicional.yo).to eql('hablaría')
      expect(hablar.condicional.tú).to eql('hablarías')
      expect(hablar.condicional.vos).to eql(hablar.condicional.tú)
      expect(hablar.condicional.él).to eql('hablaría')
      expect(hablar.condicional.ella).to eql(hablar.condicional.él)
      expect(hablar.condicional.usted).to eql(hablar.condicional.él)

      expect(hablar.condicional.nosotros).to eql('hablaríamos')
      expect(hablar.condicional.nosotras).to eql(hablar.condicional.nosotros)
      expect(hablar.condicional.vosotros).to eql('hablaríais')
      expect(hablar.condicional.vosotras).to eql(hablar.condicional.vosotros)
      expect(hablar.condicional.ellos).to eql('hablarían')
      expect(hablar.condicional.ellas).to eql(hablar.condicional.ellos)
      expect(hablar.condicional.ustedes).to eql(hablar.condicional.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish._verb('comer', Hash.new) }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.condicional.infinitive).to eql('comer')
      # expect(comer.condicional.root).to eql('com') # TODO: is it called root or stem?

      expect(comer.condicional.irregular?(:yo)).to be(false)
      expect(comer.condicional.irregular?(:tú)).to be(false)
      expect(comer.condicional.irregular?(:vos)).to be(false)
      expect(comer.condicional.irregular?(:él)).to be(false)
      expect(comer.condicional.irregular?(:ella)).to be(false)
      expect(comer.condicional.irregular?(:usted)).to be(false)
      expect(comer.condicional.irregular?(:nosotros)).to be(false)
      expect(comer.condicional.irregular?(:nosotras)).to be(false)
      expect(comer.condicional.irregular?(:vosotros)).to be(false)
      expect(comer.condicional.irregular?(:vosotras)).to be(false)
      expect(comer.condicional.irregular?(:ellos)).to be(false)
      expect(comer.condicional.irregular?(:ellas)).to be(false)
      expect(comer.condicional.irregular?(:ustedes)).to be(false)

      expect(comer.condicional.yo).to eql('comería')
      expect(comer.condicional.tú).to eql('comerías')
      expect(comer.condicional.vos).to eql(comer.condicional.tú)
      expect(comer.condicional.él).to eql('comería')
      expect(comer.condicional.ella).to eql(comer.condicional.él)
      expect(comer.condicional.usted).to eql(comer.condicional.él)

      expect(comer.condicional.nosotros).to eql('comeríamos')
      expect(comer.condicional.nosotras).to eql(comer.condicional.nosotros)
      expect(comer.condicional.vosotros).to eql('comeríais')
      expect(comer.condicional.vosotras).to eql(comer.condicional.vosotros)
      expect(comer.condicional.ellos).to eql('comerían')
      expect(comer.condicional.ellas).to eql(comer.condicional.ellos)
      expect(comer.condicional.ustedes).to eql(comer.condicional.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish._verb('vivir', Hash.new) }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.condicional.infinitive).to eql('vivir')
      # expect(vivir.condicional.root).to eql('viv') # TODO: is it called root or stem?

      expect(vivir.condicional.irregular?(:yo)).to be(false)
      expect(vivir.condicional.irregular?(:tú)).to be(false)
      expect(vivir.condicional.irregular?(:vos)).to be(false)
      expect(vivir.condicional.irregular?(:él)).to be(false)
      expect(vivir.condicional.irregular?(:ella)).to be(false)
      expect(vivir.condicional.irregular?(:usted)).to be(false)
      expect(vivir.condicional.irregular?(:nosotros)).to be(false)
      expect(vivir.condicional.irregular?(:nosotras)).to be(false)
      expect(vivir.condicional.irregular?(:vosotros)).to be(false)
      expect(vivir.condicional.irregular?(:vosotras)).to be(false)
      expect(vivir.condicional.irregular?(:ellos)).to be(false)
      expect(vivir.condicional.irregular?(:ellas)).to be(false)
      expect(vivir.condicional.irregular?(:ustedes)).to be(false)

      expect(vivir.condicional.yo).to eql('viviría')
      expect(vivir.condicional.tú).to eql('vivirías')
      expect(vivir.condicional.vos).to eql(vivir.condicional.tú)
      expect(vivir.condicional.él).to eql('viviría')
      expect(vivir.condicional.ella).to eql(vivir.condicional.él)
      expect(vivir.condicional.usted).to eql(vivir.condicional.él)

      expect(vivir.condicional.nosotros).to eql('viviríamos')
      expect(vivir.condicional.nosotras).to eql(vivir.condicional.nosotros)
      expect(vivir.condicional.vosotros).to eql('viviríais')
      expect(vivir.condicional.vosotras).to eql(vivir.condicional.vosotros)
      expect(vivir.condicional.ellos).to eql('vivirían')
      expect(vivir.condicional.ellas).to eql(vivir.condicional.ellos)
      expect(vivir.condicional.ustedes).to eql(vivir.condicional.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse', Hash.new).condicional.él).to eql(spanish._verb('hablar', Hash.new).condicional.él)
    expect(spanish._verb('comerse', Hash.new).condicional.él).to eql(spanish._verb('comer', Hash.new).condicional.él)
    expect(spanish._verb('vivirse', Hash.new).condicional.él).to eql(spanish._verb('vivir', Hash.new).condicional.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
