require 'flashcards'
require 'flashcards/language'

describe 'Imperfecto' do
  let(:app)     { Flashcards::App.new(:es) }
  let(:spanish) { app.language }

  before do
    spanish.flashcards = [
      Flashcards::Flashcard.new(expressions: ['hablar', 'hablarse'], translation: 'to speak', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['comer', 'comerse'], translation: 'to eat', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['vivir', 'vivirse'], translation: 'to live', tags: [:verb])
    ]
  end

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.load_verb(app, 'hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.imperfecto.infinitive).to eql('hablar')
      # expect(hablar.imperfecto.stem).to eql('habl')

      expect(hablar.imperfecto.irregular?(:yo)).to be(false)
      expect(hablar.imperfecto.irregular?(:tú)).to be(false)
      expect(hablar.imperfecto.irregular?(:vos)).to be(false)
      expect(hablar.imperfecto.irregular?(:él)).to be(false)
      expect(hablar.imperfecto.irregular?(:ella)).to be(false)
      expect(hablar.imperfecto.irregular?(:usted)).to be(false)
      expect(hablar.imperfecto.irregular?(:nosotros)).to be(false)
      expect(hablar.imperfecto.irregular?(:nosotras)).to be(false)
      expect(hablar.imperfecto.irregular?(:vosotros)).to be(false)
      expect(hablar.imperfecto.irregular?(:vosotras)).to be(false)
      expect(hablar.imperfecto.irregular?(:ellos)).to be(false)
      expect(hablar.imperfecto.irregular?(:ellas)).to be(false)
      expect(hablar.imperfecto.irregular?(:ustedes)).to be(false)

      expect(hablar.imperfecto.yo).to eql('hablaba')
      expect(hablar.imperfecto.tú).to eql('hablabas')
      expect(hablar.imperfecto.vos).to eql(hablar.imperfecto.tú)
      expect(hablar.imperfecto.él).to eql('hablaba')
      expect(hablar.imperfecto.ella).to eql(hablar.imperfecto.él)
      expect(hablar.imperfecto.usted).to eql(hablar.imperfecto.él)

      expect(hablar.imperfecto.nosotros).to eql('hablábamos')
      expect(hablar.imperfecto.nosotras).to eql(hablar.imperfecto.nosotros)
      expect(hablar.imperfecto.vosotros).to eql('hablabais')
      expect(hablar.imperfecto.vosotras).to eql(hablar.imperfecto.vosotros)
      expect(hablar.imperfecto.ellos).to eql('hablaban')
      expect(hablar.imperfecto.ellas).to eql(hablar.imperfecto.ellos)
      expect(hablar.imperfecto.ustedes).to eql(hablar.imperfecto.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.load_verb(app, 'comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.imperfecto.infinitive).to eql('comer')
      # expect(comer.imperfecto.stem).to eql('com')

      expect(comer.imperfecto.irregular?(:yo)).to be(false)
      expect(comer.imperfecto.irregular?(:tú)).to be(false)
      expect(comer.imperfecto.irregular?(:vos)).to be(false)
      expect(comer.imperfecto.irregular?(:él)).to be(false)
      expect(comer.imperfecto.irregular?(:ella)).to be(false)
      expect(comer.imperfecto.irregular?(:usted)).to be(false)
      expect(comer.imperfecto.irregular?(:nosotros)).to be(false)
      expect(comer.imperfecto.irregular?(:nosotras)).to be(false)
      expect(comer.imperfecto.irregular?(:vosotros)).to be(false)
      expect(comer.imperfecto.irregular?(:vosotras)).to be(false)
      expect(comer.imperfecto.irregular?(:ellos)).to be(false)
      expect(comer.imperfecto.irregular?(:ellas)).to be(false)
      expect(comer.imperfecto.irregular?(:ustedes)).to be(false)

      expect(comer.imperfecto.yo).to eql('comía')
      expect(comer.imperfecto.tú).to eql('comías')
      expect(comer.imperfecto.vos).to eql(comer.imperfecto.tú)
      expect(comer.imperfecto.él).to eql('comía')
      expect(comer.imperfecto.ella).to eql(comer.imperfecto.él)
      expect(comer.imperfecto.usted).to eql(comer.imperfecto.él)

      expect(comer.imperfecto.nosotros).to eql('comíamos')
      expect(comer.imperfecto.nosotras).to eql(comer.imperfecto.nosotros)
      expect(comer.imperfecto.vosotros).to eql('comíais')
      expect(comer.imperfecto.vosotras).to eql(comer.imperfecto.vosotros)
      expect(comer.imperfecto.ellos).to eql('comían')
      expect(comer.imperfecto.ellas).to eql(comer.imperfecto.ellos)
      expect(comer.imperfecto.ustedes).to eql(comer.imperfecto.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.load_verb(app, 'vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.imperfecto.infinitive).to eql('vivir')
      # expect(vivir.imperfecto.stem).to eql('viv')

      expect(vivir.imperfecto.irregular?(:yo)).to be(false)
      expect(vivir.imperfecto.irregular?(:tú)).to be(false)
      expect(vivir.imperfecto.irregular?(:vos)).to be(false)
      expect(vivir.imperfecto.irregular?(:él)).to be(false)
      expect(vivir.imperfecto.irregular?(:ella)).to be(false)
      expect(vivir.imperfecto.irregular?(:usted)).to be(false)
      expect(vivir.imperfecto.irregular?(:nosotros)).to be(false)
      expect(vivir.imperfecto.irregular?(:nosotras)).to be(false)
      expect(vivir.imperfecto.irregular?(:vosotros)).to be(false)
      expect(vivir.imperfecto.irregular?(:vosotras)).to be(false)
      expect(vivir.imperfecto.irregular?(:ellos)).to be(false)
      expect(vivir.imperfecto.irregular?(:ellas)).to be(false)
      expect(vivir.imperfecto.irregular?(:ustedes)).to be(false)

      expect(vivir.imperfecto.yo).to eql('vivía')
      expect(vivir.imperfecto.tú).to eql('vivías')
      expect(vivir.imperfecto.vos).to eql(vivir.imperfecto.tú)
      expect(vivir.imperfecto.él).to eql('vivía')
      expect(vivir.imperfecto.ella).to eql(vivir.imperfecto.él)
      expect(vivir.imperfecto.usted).to eql(vivir.imperfecto.él)

      expect(vivir.imperfecto.nosotros).to eql('vivíamos')
      expect(vivir.imperfecto.nosotras).to eql(vivir.imperfecto.nosotros)
      expect(vivir.imperfecto.vosotros).to eql('vivíais')
      expect(vivir.imperfecto.vosotras).to eql(vivir.imperfecto.vosotros)
      expect(vivir.imperfecto.ellos).to eql('vivían')
      expect(vivir.imperfecto.ellas).to eql(vivir.imperfecto.ellos)
      expect(vivir.imperfecto.ustedes).to eql(vivir.imperfecto.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.load_verb(app, 'hablarse').imperfecto.él).to eql(spanish.load_verb(app, 'hablar').imperfecto.él)
    expect(spanish.load_verb(app, 'comerse').imperfecto.él).to eql(spanish.load_verb(app, 'comer').imperfecto.él)
    expect(spanish.load_verb(app, 'vivirse').imperfecto.él).to eql(spanish.load_verb(app, 'vivir').imperfecto.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
