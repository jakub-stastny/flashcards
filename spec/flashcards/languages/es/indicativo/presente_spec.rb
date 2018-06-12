# frozen_string_literal: true

require 'spec_helper'
require 'flashcards'
require 'flashcards/language'

describe 'Presente' do
  let(:app)     { Flashcards::App.new(:es) }
  let(:spanish) { app.language }

  before do
    spanish.flashcards = [
      Flashcards::Flashcard.new(expressions: ['hablar', 'hablarse'], translation: 'to speak', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['comer', 'comerse'], translation: 'to eat', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['vivir', 'vivirse'], translation: 'to live', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['extinguir'], translation: 'to extinguish', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['escoger'], translation: 'to choose', tags: [:verb]),
      Flashcards::Flashcard.new(expressions: ['dirigir'], translation: 'to manage', tags: [:verb])
    ]
  end

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.load_verb(app, 'hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.presente.infinitive).to eql('hablar')
      expect(hablar.presente.stem).to eql('habl')

      expect(hablar.presente.irregular?(:yo)).to be(false)
      expect(hablar.presente.irregular?(:tú)).to be(false)
      expect(hablar.presente.irregular?(:vos)).to be(false)
      expect(hablar.presente.irregular?(:él)).to be(false)
      expect(hablar.presente.irregular?(:ella)).to be(false)
      expect(hablar.presente.irregular?(:usted)).to be(false)
      expect(hablar.presente.irregular?(:nosotros)).to be(false)
      expect(hablar.presente.irregular?(:nosotras)).to be(false)
      expect(hablar.presente.irregular?(:vosotros)).to be(false)
      expect(hablar.presente.irregular?(:vosotras)).to be(false)
      expect(hablar.presente.irregular?(:ellos)).to be(false)
      expect(hablar.presente.irregular?(:ellas)).to be(false)
      expect(hablar.presente.irregular?(:ustedes)).to be(false)

      expect(hablar.presente.yo).to eql('hablo')
      expect(hablar.presente.tú).to eql('hablas')
      expect(hablar.presente.vos).to eql('hablás')
      expect(hablar.presente.él).to eql('habla')
      expect(hablar.presente.ella).to eql(hablar.presente.él)
      expect(hablar.presente.usted).to eql(hablar.presente.él)

      expect(hablar.presente.nosotros).to eql('hablamos')
      expect(hablar.presente.nosotras).to eql(hablar.presente.nosotros)
      expect(hablar.presente.vosotros).to eql('habláis')
      expect(hablar.presente.vosotras).to eql(hablar.presente.vosotros)
      expect(hablar.presente.ellos).to eql('hablan')
      expect(hablar.presente.ellas).to eql(hablar.presente.ellos)
      expect(hablar.presente.ustedes).to eql(hablar.presente.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.load_verb(app, 'comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.presente.infinitive).to eql('comer')
      expect(comer.presente.stem).to eql('com')

      expect(comer.presente.irregular?(:yo)).to be(false)
      expect(comer.presente.irregular?(:tú)).to be(false)
      expect(comer.presente.irregular?(:vos)).to be(false)
      expect(comer.presente.irregular?(:él)).to be(false)
      expect(comer.presente.irregular?(:ella)).to be(false)
      expect(comer.presente.irregular?(:usted)).to be(false)
      expect(comer.presente.irregular?(:nosotros)).to be(false)
      expect(comer.presente.irregular?(:nosotras)).to be(false)
      expect(comer.presente.irregular?(:vosotros)).to be(false)
      expect(comer.presente.irregular?(:vosotras)).to be(false)
      expect(comer.presente.irregular?(:ellos)).to be(false)
      expect(comer.presente.irregular?(:ellas)).to be(false)
      expect(comer.presente.irregular?(:ustedes)).to be(false)

      expect(comer.presente.yo).to eql('como')
      expect(comer.presente.tú).to eql('comes')
      expect(comer.presente.vos).to eql('comés')
      expect(comer.presente.él).to eql('come')
      expect(comer.presente.ella).to eql(comer.presente.él)
      expect(comer.presente.usted).to eql(comer.presente.él)

      expect(comer.presente.nosotros).to eql('comemos')
      expect(comer.presente.nosotras).to eql(comer.presente.nosotros)
      expect(comer.presente.vosotros).to eql('coméis')
      expect(comer.presente.vosotras).to eql(comer.presente.vosotros)
      expect(comer.presente.ellos).to eql('comen')
      expect(comer.presente.ellas).to eql(comer.presente.ellos)
      expect(comer.presente.ustedes).to eql(comer.presente.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.load_verb(app, 'vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.presente.infinitive).to eql('vivir')
      expect(vivir.presente.stem).to eql('viv')

      expect(vivir.presente.irregular?(:yo)).to be(false)
      expect(vivir.presente.irregular?(:tú)).to be(false)
      expect(vivir.presente.irregular?(:vos)).to be(false)
      expect(vivir.presente.irregular?(:él)).to be(false)
      expect(vivir.presente.irregular?(:ella)).to be(false)
      expect(vivir.presente.irregular?(:usted)).to be(false)
      expect(vivir.presente.irregular?(:nosotros)).to be(false)
      expect(vivir.presente.irregular?(:nosotras)).to be(false)
      expect(vivir.presente.irregular?(:vosotros)).to be(false)
      expect(vivir.presente.irregular?(:vosotras)).to be(false)
      expect(vivir.presente.irregular?(:ellos)).to be(false)
      expect(vivir.presente.irregular?(:ellas)).to be(false)
      expect(vivir.presente.irregular?(:ustedes)).to be(false)

      expect(vivir.presente.yo).to eql('vivo')
      expect(vivir.presente.tú).to eql('vives')
      expect(vivir.presente.vos).to eql('vivís')
      expect(vivir.presente.él).to eql('vive')
      expect(vivir.presente.ella).to eql(vivir.presente.él)
      expect(vivir.presente.usted).to eql(vivir.presente.él)

      expect(vivir.presente.nosotros).to eql('vivimos')
      expect(vivir.presente.nosotras).to eql(vivir.presente.nosotros)
      expect(vivir.presente.vosotros).to eql('vivís')
      expect(vivir.presente.vosotras).to eql(vivir.presente.vosotros)
      expect(vivir.presente.ellos).to eql('viven')
      expect(vivir.presente.ellas).to eql(vivir.presente.ellos)
      expect(vivir.presente.ustedes).to eql(vivir.presente.ellos)
    end
  end

  describe 'extinguir' do
    let(:extinguir) { spanish.load_verb(app, 'extinguir') }

    it 'is irregular in the first form of singular' do
      expect(extinguir.infinitive).to eql('extinguir')
      expect(extinguir.presente.infinitive).to eql('extinguir')
      expect(extinguir.presente.stem).to eql('extingu') # Plus is this the real stem?

      expect(extinguir.presente.irregular?(:yo)).to be(true)
      expect(extinguir.presente.irregular?(:tú)).to be(false)
      expect(extinguir.presente.irregular?(:vos)).to be(false)
      expect(extinguir.presente.irregular?(:él)).to be(false)
      expect(extinguir.presente.irregular?(:ella)).to be(false)
      expect(extinguir.presente.irregular?(:usted)).to be(false)
      expect(extinguir.presente.irregular?(:nosotros)).to be(false)
      expect(extinguir.presente.irregular?(:nosotras)).to be(false)
      expect(extinguir.presente.irregular?(:vosotros)).to be(false)
      expect(extinguir.presente.irregular?(:vosotras)).to be(false)
      expect(extinguir.presente.irregular?(:ellos)).to be(false)
      expect(extinguir.presente.irregular?(:ellas)).to be(false)
      expect(extinguir.presente.irregular?(:ustedes)).to be(false)

      expect(extinguir.presente.yo).to eql('extingo')
      expect(extinguir.presente.tú).to eql('extingues')
      expect(extinguir.presente.vos).to eql('extinguís')
      expect(extinguir.presente.él).to eql('extingue')
      expect(extinguir.presente.ella).to eql(extinguir.presente.él)
      expect(extinguir.presente.usted).to eql(extinguir.presente.él)

      expect(extinguir.presente.nosotros).to eql('extinguimos')
      expect(extinguir.presente.nosotras).to eql(extinguir.presente.nosotros)
      expect(extinguir.presente.vosotros).to eql('extinguís')
      expect(extinguir.presente.vosotras).to eql(extinguir.presente.vosotros)
      expect(extinguir.presente.ellos).to eql('extinguen')
      expect(extinguir.presente.ellas).to eql(extinguir.presente.ellos)
      expect(extinguir.presente.ustedes).to eql(extinguir.presente.ellos)
    end
  end

  describe 'escoger' do
    let(:escoger) { spanish.load_verb(app, 'escoger') }

    it 'is irregular in the first form of singular' do
      expect(escoger.infinitive).to eql('escoger')
      expect(escoger.presente.infinitive).to eql('escoger')
      expect(escoger.presente.stem).to eql('escog') # Plus is this the real stem?

      expect(escoger.presente.irregular?(:yo)).to be(true)
      expect(escoger.presente.irregular?(:tú)).to be(false)
      expect(escoger.presente.irregular?(:vos)).to be(false)
      expect(escoger.presente.irregular?(:él)).to be(false)
      expect(escoger.presente.irregular?(:ella)).to be(false)
      expect(escoger.presente.irregular?(:usted)).to be(false)
      expect(escoger.presente.irregular?(:nosotros)).to be(false)
      expect(escoger.presente.irregular?(:nosotras)).to be(false)
      expect(escoger.presente.irregular?(:vosotros)).to be(false)
      expect(escoger.presente.irregular?(:vosotras)).to be(false)
      expect(escoger.presente.irregular?(:ellos)).to be(false)
      expect(escoger.presente.irregular?(:ellas)).to be(false)
      expect(escoger.presente.irregular?(:ustedes)).to be(false)

      expect(escoger.presente.yo).to eql('escojo')
      expect(escoger.presente.tú).to eql('escoges')
      expect(escoger.presente.vos).to eql('escogés')
      expect(escoger.presente.él).to eql('escoge')
      expect(escoger.presente.ella).to eql(escoger.presente.él)
      expect(escoger.presente.usted).to eql(escoger.presente.él)

      expect(escoger.presente.nosotros).to eql('escogemos')
      expect(escoger.presente.nosotras).to eql(escoger.presente.nosotros)
      expect(escoger.presente.vosotros).to eql('escogéis')
      expect(escoger.presente.vosotras).to eql(escoger.presente.vosotros)
      expect(escoger.presente.ellos).to eql('escogen')
      expect(escoger.presente.ellas).to eql(escoger.presente.ellos)
      expect(escoger.presente.ustedes).to eql(escoger.presente.ellos)
    end
  end

  describe 'dirigir' do
    let(:dirigir) { spanish.load_verb(app, 'dirigir') }

    it 'is irregular in the first form of singular' do
      expect(dirigir.infinitive).to eql('dirigir')
      expect(dirigir.presente.infinitive).to eql('dirigir')
      expect(dirigir.presente.stem).to eql('dirig') # Plus is this the real stem?

      expect(dirigir.presente.irregular?(:yo)).to be(true)
      expect(dirigir.presente.irregular?(:tú)).to be(false)
      expect(dirigir.presente.irregular?(:vos)).to be(false)
      expect(dirigir.presente.irregular?(:él)).to be(false)
      expect(dirigir.presente.irregular?(:ella)).to be(false)
      expect(dirigir.presente.irregular?(:usted)).to be(false)
      expect(dirigir.presente.irregular?(:nosotros)).to be(false)
      expect(dirigir.presente.irregular?(:nosotras)).to be(false)
      expect(dirigir.presente.irregular?(:vosotros)).to be(false)
      expect(dirigir.presente.irregular?(:vosotras)).to be(false)
      expect(dirigir.presente.irregular?(:ellos)).to be(false)
      expect(dirigir.presente.irregular?(:ellas)).to be(false)
      expect(dirigir.presente.irregular?(:ustedes)).to be(false)

      expect(dirigir.presente.yo).to eql('dirijo')
      expect(dirigir.presente.tú).to eql('diriges')
      expect(dirigir.presente.vos).to eql('dirigís')
      expect(dirigir.presente.él).to eql('dirige')
      expect(dirigir.presente.ella).to eql(dirigir.presente.él)
      expect(dirigir.presente.usted).to eql(dirigir.presente.él)

      expect(dirigir.presente.nosotros).to eql('dirigimos')
      expect(dirigir.presente.nosotras).to eql(dirigir.presente.nosotros)
      expect(dirigir.presente.vosotros).to eql('dirigís')
      expect(dirigir.presente.vosotras).to eql(dirigir.presente.vosotros)
      expect(dirigir.presente.ellos).to eql('dirigen')
      expect(dirigir.presente.ellas).to eql(dirigir.presente.ellos)
      expect(dirigir.presente.ustedes).to eql(dirigir.presente.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.load_verb(app, 'hablarse').presente.él).to eql(spanish.load_verb(app, 'hablar').presente.él)
    expect(spanish.load_verb(app, 'comerse').presente.él).to eql(spanish.load_verb(app, 'comer').presente.él)
    expect(spanish.load_verb(app, 'vivirse').presente.él).to eql(spanish.load_verb(app, 'vivir').presente.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
