require 'flashcards'
require 'flashcards/language'

describe 'Subjunctivo imperfecto' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish._verb('hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.subjunctivo_imperfecto.infinitive).to eql('hablar')
      # expect(hablar.subjunctivo_imperfecto.root).to eql('habl') # TODO: is it called root or stem?

      expect(hablar.subjunctivo_imperfecto.irregular?(:yo)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:tú)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:vos)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:él)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:ella)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:usted)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:nosotros)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:nosotras)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:vosotros)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:vosotras)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:ellos)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:ellas)).to be(false)
      expect(hablar.subjunctivo_imperfecto.irregular?(:ustedes)).to be(false)

      expect(hablar.subjunctivo_imperfecto.yo).to eql(['hablara', 'hablase'])
      expect(hablar.subjunctivo_imperfecto.tú).to eql(['hablaras', 'hablases'])
      expect(hablar.subjunctivo_imperfecto.vos).to eql(hablar.subjunctivo_imperfecto.tú)
      expect(hablar.subjunctivo_imperfecto.él).to eql(['hablara', 'hablase'])
      expect(hablar.subjunctivo_imperfecto.ella).to eql(hablar.subjunctivo_imperfecto.él)
      expect(hablar.subjunctivo_imperfecto.usted).to eql(hablar.subjunctivo_imperfecto.él)

      expect(hablar.subjunctivo_imperfecto.nosotros).to eql(['hablaramos', 'hablasemos'])
      expect(hablar.subjunctivo_imperfecto.nosotras).to eql(hablar.subjunctivo_imperfecto.nosotros)
      expect(hablar.subjunctivo_imperfecto.vosotros).to eql(['hablarais', 'hablaseis'])
      expect(hablar.subjunctivo_imperfecto.vosotras).to eql(hablar.subjunctivo_imperfecto.vosotros)
      expect(hablar.subjunctivo_imperfecto.ellos).to eql(['hablaran', 'hablasen'])
      expect(hablar.subjunctivo_imperfecto.ellas).to eql(hablar.subjunctivo_imperfecto.ellos)
      expect(hablar.subjunctivo_imperfecto.ustedes).to eql(hablar.subjunctivo_imperfecto.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish._verb('comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.subjunctivo_imperfecto.infinitive).to eql('comer')
      # expect(comer.subjunctivo_imperfecto.root).to eql('com') # TODO: is it called root or stem?

      expect(comer.subjunctivo_imperfecto.irregular?(:yo)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:tú)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:vos)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:él)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:ella)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:usted)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:nosotros)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:nosotras)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:vosotros)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:vosotras)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:ellos)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:ellas)).to be(false)
      expect(comer.subjunctivo_imperfecto.irregular?(:ustedes)).to be(false)

      expect(comer.subjunctivo_imperfecto.yo).to eql(['comiera', 'comiese'])
      expect(comer.subjunctivo_imperfecto.tú).to eql(['comieras', 'comieses'])
      expect(comer.subjunctivo_imperfecto.vos).to eql(comer.subjunctivo_imperfecto.tú)
      expect(comer.subjunctivo_imperfecto.él).to eql(['comiera', 'comiese'])
      expect(comer.subjunctivo_imperfecto.ella).to eql(comer.subjunctivo_imperfecto.él)
      expect(comer.subjunctivo_imperfecto.usted).to eql(comer.subjunctivo_imperfecto.él)

      expect(comer.subjunctivo_imperfecto.nosotros).to eql(['comieramos', 'comiesemos'])
      expect(comer.subjunctivo_imperfecto.nosotras).to eql(comer.subjunctivo_imperfecto.nosotros)
      expect(comer.subjunctivo_imperfecto.vosotros).to eql(['comierais', 'comieseis'])
      expect(comer.subjunctivo_imperfecto.vosotras).to eql(comer.subjunctivo_imperfecto.vosotros)
      expect(comer.subjunctivo_imperfecto.ellos).to eql(['comieran', 'comiesen'])
      expect(comer.subjunctivo_imperfecto.ellas).to eql(comer.subjunctivo_imperfecto.ellos)
      expect(comer.subjunctivo_imperfecto.ustedes).to eql(comer.subjunctivo_imperfecto.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish._verb('vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.subjunctivo_imperfecto.infinitive).to eql('vivir')
      # expect(vivir.subjunctivo_imperfecto.root).to eql('viv') # TODO: is it called root or stem?

      expect(vivir.subjunctivo_imperfecto.irregular?(:yo)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:tú)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:vos)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:él)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:ella)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:usted)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:nosotros)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:nosotras)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:vosotros)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:vosotras)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:ellos)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:ellas)).to be(false)
      expect(vivir.subjunctivo_imperfecto.irregular?(:ustedes)).to be(false)

      expect(vivir.subjunctivo_imperfecto.yo).to eql(['viviera', 'viviese'])
      expect(vivir.subjunctivo_imperfecto.tú).to eql(['vivieras', 'vivieses'])
      expect(vivir.subjunctivo_imperfecto.vos).to eql(vivir.subjunctivo_imperfecto.tú)
      expect(vivir.subjunctivo_imperfecto.él).to eql(['viviera', 'viviese'])
      expect(vivir.subjunctivo_imperfecto.ella).to eql(vivir.subjunctivo_imperfecto.él)
      expect(vivir.subjunctivo_imperfecto.usted).to eql(vivir.subjunctivo_imperfecto.él)

      expect(vivir.subjunctivo_imperfecto.nosotros).to eql(['vivieramos', 'viviesemos'])
      expect(vivir.subjunctivo_imperfecto.nosotras).to eql(vivir.subjunctivo_imperfecto.nosotros)
      expect(vivir.subjunctivo_imperfecto.vosotros).to eql(['vivierais', 'vivieseis'])
      expect(vivir.subjunctivo_imperfecto.vosotras).to eql(vivir.subjunctivo_imperfecto.vosotros)
      expect(vivir.subjunctivo_imperfecto.ellos).to eql(['vivieran', 'viviesen'])
      expect(vivir.subjunctivo_imperfecto.ellas).to eql(vivir.subjunctivo_imperfecto.ellos)
      expect(vivir.subjunctivo_imperfecto.ustedes).to eql(vivir.subjunctivo_imperfecto.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse').subjunctivo_imperfecto.él).to eql(spanish._verb('hablar').subjunctivo_imperfecto.él)
    expect(spanish._verb('comerse').subjunctivo_imperfecto.él).to eql(spanish._verb('comer').subjunctivo_imperfecto.él)
    expect(spanish._verb('vivirse').subjunctivo_imperfecto.él).to eql(spanish._verb('vivir').subjunctivo_imperfecto.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
