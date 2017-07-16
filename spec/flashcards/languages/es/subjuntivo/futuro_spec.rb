require 'flashcards'
require 'flashcards/language'

describe 'Subjunctivo futuro' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish._verb('hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.subjunctivo_futuro.infinitive).to eql('hablar')
      # expect(hablar.subjunctivo_futuro.root).to eql('habl') # TODO: is it called root or stem?

      expect(hablar.subjunctivo_futuro.irregular?(:yo)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:tú)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:vos)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:él)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:ella)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:usted)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:nosotros)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:nosotras)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:vosotros)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:vosotras)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:ellos)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:ellas)).to be(false)
      expect(hablar.subjunctivo_futuro.irregular?(:ustedes)).to be(false)

      expect(hablar.subjunctivo_futuro.yo).to eql('hablare')
      expect(hablar.subjunctivo_futuro.tú).to eql('hablares')
      expect(hablar.subjunctivo_futuro.vos).to eql(hablar.subjunctivo_futuro.tú)
      expect(hablar.subjunctivo_futuro.él).to eql('hablare')
      expect(hablar.subjunctivo_futuro.ella).to eql(hablar.subjunctivo_futuro.él)
      expect(hablar.subjunctivo_futuro.usted).to eql(hablar.subjunctivo_futuro.él)

      expect(hablar.subjunctivo_futuro.nosotros).to eql('hablaremos')
      expect(hablar.subjunctivo_futuro.nosotras).to eql(hablar.subjunctivo_futuro.nosotros)
      expect(hablar.subjunctivo_futuro.vosotros).to eql('hablareis')
      expect(hablar.subjunctivo_futuro.vosotras).to eql(hablar.subjunctivo_futuro.vosotros)
      expect(hablar.subjunctivo_futuro.ellos).to eql('hablaren')
      expect(hablar.subjunctivo_futuro.ellas).to eql(hablar.subjunctivo_futuro.ellos)
      expect(hablar.subjunctivo_futuro.ustedes).to eql(hablar.subjunctivo_futuro.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish._verb('comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.subjunctivo_futuro.infinitive).to eql('comer')
      # expect(comer.subjunctivo_futuro.root).to eql('com') # TODO: is it called root or stem?

      expect(comer.subjunctivo_futuro.irregular?(:yo)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:tú)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:vos)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:él)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:ella)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:usted)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:nosotros)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:nosotras)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:vosotros)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:vosotras)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:ellos)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:ellas)).to be(false)
      expect(comer.subjunctivo_futuro.irregular?(:ustedes)).to be(false)

      expect(comer.subjunctivo_futuro.yo).to eql('comiere')
      expect(comer.subjunctivo_futuro.tú).to eql('comieres')
      expect(comer.subjunctivo_futuro.vos).to eql(comer.subjunctivo_futuro.tú)
      expect(comer.subjunctivo_futuro.él).to eql('comiere')
      expect(comer.subjunctivo_futuro.ella).to eql(comer.subjunctivo_futuro.él)
      expect(comer.subjunctivo_futuro.usted).to eql(comer.subjunctivo_futuro.él)

      expect(comer.subjunctivo_futuro.nosotros).to eql('comieremos')
      expect(comer.subjunctivo_futuro.nosotras).to eql(comer.subjunctivo_futuro.nosotros)
      expect(comer.subjunctivo_futuro.vosotros).to eql('comiereis')
      expect(comer.subjunctivo_futuro.vosotras).to eql(comer.subjunctivo_futuro.vosotros)
      expect(comer.subjunctivo_futuro.ellos).to eql('comieren')
      expect(comer.subjunctivo_futuro.ellas).to eql(comer.subjunctivo_futuro.ellos)
      expect(comer.subjunctivo_futuro.ustedes).to eql(comer.subjunctivo_futuro.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish._verb('vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.subjunctivo_futuro.infinitive).to eql('vivir')
      # expect(vivir.subjunctivo_futuro.root).to eql('viv') # TODO: is it called root or stem?

      expect(vivir.subjunctivo_futuro.irregular?(:yo)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:tú)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:vos)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:él)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:ella)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:usted)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:nosotros)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:nosotras)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:vosotros)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:vosotras)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:ellos)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:ellas)).to be(false)
      expect(vivir.subjunctivo_futuro.irregular?(:ustedes)).to be(false)

      expect(vivir.subjunctivo_futuro.yo).to eql('viviere')
      expect(vivir.subjunctivo_futuro.tú).to eql('vivieres')
      expect(vivir.subjunctivo_futuro.vos).to eql(vivir.subjunctivo_futuro.tú)
      expect(vivir.subjunctivo_futuro.él).to eql('viviere')
      expect(vivir.subjunctivo_futuro.ella).to eql(vivir.subjunctivo_futuro.él)
      expect(vivir.subjunctivo_futuro.usted).to eql(vivir.subjunctivo_futuro.él)

      expect(vivir.subjunctivo_futuro.nosotros).to eql('vivieremos')
      expect(vivir.subjunctivo_futuro.nosotras).to eql(vivir.subjunctivo_futuro.nosotros)
      expect(vivir.subjunctivo_futuro.vosotros).to eql('viviereis')
      expect(vivir.subjunctivo_futuro.vosotras).to eql(vivir.subjunctivo_futuro.vosotros)
      expect(vivir.subjunctivo_futuro.ellos).to eql('vivieren')
      expect(vivir.subjunctivo_futuro.ellas).to eql(vivir.subjunctivo_futuro.ellos)
      expect(vivir.subjunctivo_futuro.ustedes).to eql(vivir.subjunctivo_futuro.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse').subjunctivo_futuro.él).to eql(spanish._verb('hablar').subjunctivo_futuro.él)
    expect(spanish._verb('comerse').subjunctivo_futuro.él).to eql(spanish._verb('comer').subjunctivo_futuro.él)
    expect(spanish._verb('vivirse').subjunctivo_futuro.él).to eql(spanish._verb('vivir').subjunctivo_futuro.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
