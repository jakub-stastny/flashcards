require 'spec_helper'
require 'flashcards'
require 'flashcards/language'

describe 'Gerundio' do
  let(:spanish) { Flashcards.app.language }

  before(:each) do
    Flashcards.app.language.flashcards = default_flashcards
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

  describe 'verbs changing to -yendo' do
    before(:each) do
      Flashcards.app.language.flashcards += [
        Flashcards::Flashcard.new(expressions: ['atraer'], translation: 'to attract', tags: [:verb])
      ]
    end

    let(:atraer) { spanish.load_verb('atraer') }

    it 'is irregular' do
      expect(atraer.gerundio.regular?).to be(false)
      expect(atraer.gerundio.default).to eql('atrayendo')
    end
  end

  describe 'verbs changing to -endo' do
    before(:each) do
      Flashcards.app.language.flashcards += [
        Flashcards::Flashcard.new(expressions: ['tañer'], translation: 'to strum', tags: [:verb]),
        Flashcards::Flashcard.new(expressions: ['bullir'], translation: 'to boil', tags: [:verb]),
        Flashcards::Flashcard.new(expressions: ['engullir'], translation: 'to gobble', tags: [:verb])
      ]
    end

    let(:tañer)    { spanish.load_verb('tañer') }
    let(:bullir)   { spanish.load_verb('bullir') }
    let(:engullir) { spanish.load_verb('engullir') }

    it 'is irregular' do
      expect(tañer.gerundio.regular?).to be(false)
      expect(tañer.gerundio.default).to eql('tañendo')

      expect(bullir.gerundio.regular?).to be(false)
      expect(bullir.gerundio.default).to eql('bullendo')

      expect(engullir.gerundio.regular?).to be(false)
      expect(engullir.gerundio.default).to eql('engullendo')
    end
  end

  describe 'verbs with stem changes in the preterite' do
    before(:each) do
      Flashcards.app.language.flashcards += [
        Flashcards::Flashcard.new(expressions: ['dormir'], translation: 'to sleep', tags: [:verb], conjugations: {pretérito: {él: 'durmió'}}),
        Flashcards::Flashcard.new(expressions: ['decir'], translation: 'to tell', tags: [:verb], conjugations: {pretérito: {él: 'dijo'}}),
        Flashcards::Flashcard.new(expressions: ['reñir'], translation: 'to tell off', tags: [:verb], conjugations: {pretérito: {él: 'riñó'}}),
      ]
    end

    let(:dormir) { spanish.load_verb('dormir') }
    let(:decir)  { spanish.load_verb('decir') }
    let(:reñir)  { spanish.load_verb('reñir') }

    it 'is irregular' do
      pending 'Add these exceptions to the preterite first.' ###
      # Then check https://www.spanishdict.com/guide/present-participles-in-spanish
      # expect(dormir.gerundio.regular?).to be(false)
      expect(dormir.gerundio.default).to eql('durmiendo')

      # expect(decir.gerundio.regular?).to be(false)
      expect(decir.gerundio.default).to eql('diciendo')

      # expect(reñir.gerundio.regular?).to be(false)
      expect(reñir.gerundio.default).to eql('riñendo')
    end
  end

  it 'handles reflective verbs' do
    expect(spanish.load_verb('hablarse').gerundio.default).to eql(spanish.load_verb('hablar').gerundio.default)
    expect(spanish.load_verb('comerse').gerundio.default).to eql(spanish.load_verb('comer').gerundio.default)
    expect(spanish.load_verb('vivirse').gerundio.default).to eql(spanish.load_verb('vivir').gerundio.default)
  end

  # TODO: How about ir? What's the stem of voy?
end
