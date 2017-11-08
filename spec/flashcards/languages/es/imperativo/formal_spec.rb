require 'flashcards'
require 'flashcards/language'

describe 'Formal commands' do
  let(:app)     { Flashcards::App.new(:es) }
  let(:spanish) { app.language }

  before do
    spanish.flashcards = [
      Flashcards::Flashcard.new(expressions: ['hablar', 'hablarse'], translation: 'to speak', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['comer', 'comerse'], translation: 'to eat', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['vivir', 'vivirse'], translation: 'to live', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['tener'], translation: 'to have', tags: [:verb], conjugations: {subjuntivo: {él: 'tenga', ellos: 'tengan'}})
    ]
  end

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.load_verb(app, 'hablar') }

    it 'is regular' do
      expect(hablar.imperativo_formal.irregular?(:usted)).to be(false)
      expect(hablar.imperativo_formal.irregular?(:ustedes)).to be(false)

      expect(hablar.imperativo_formal.usted).to eql('hable')
      expect(hablar.imperativo_formal.ustedes).to eql('hablen')
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.load_verb(app, 'comer') }

    it 'is regular' do
      expect(comer.imperativo_formal.irregular?(:usted)).to be(false)
      expect(comer.imperativo_formal.irregular?(:ustedes)).to be(false)

      expect(comer.imperativo_formal.usted).to eql('coma')
      expect(comer.imperativo_formal.ustedes).to eql('coman')
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.load_verb(app, 'vivir') }

    it 'is regular' do
      expect(vivir.imperativo_formal.irregular?(:usted)).to be(false)
      expect(vivir.imperativo_formal.irregular?(:ustedes)).to be(false)

      expect(vivir.imperativo_formal.usted).to eql('viva')
      expect(vivir.imperativo_formal.ustedes).to eql('vivan')
    end
  end

  describe 'verbs with an irregular subjunctive' do
    let(:tener) { spanish.load_verb(app, 'tener') }

    # TODO: Is it regular or irregular?
    # It is regular as in "it does not differ from the subjunctive".
    # However since no verb differs from the subjunctive, it is the subjunctive
    # rather than a "proxy-with-tweaks" as is the positive command which has
    # its own exceptions ("ten!") or the negative command which has an extra "-s".
    it 'is regular' do
      expect(tener.imperativo_formal.irregular?(:usted)).to be(false)
      expect(tener.imperativo_formal.irregular?(:ustedes)).to be(false)

      expect(tener.imperativo_formal.usted).to eql('tenga')
      expect(tener.imperativo_formal.ustedes).to eql('tengan')
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.load_verb(app, 'hablarse').imperativo_formal.usted).to eql(spanish.load_verb(app, 'hablar').imperativo_formal.usted)
    expect(spanish.load_verb(app, 'comerse').imperativo_formal.usted).to eql(spanish.load_verb(app, 'comer').imperativo_formal.usted)
    expect(spanish.load_verb(app, 'vivirse').imperativo_formal.usted).to eql(spanish.load_verb(app, 'vivir').imperativo_formal.usted)
  end

  # TODO: How about ir? What's the stem of voy?
end
