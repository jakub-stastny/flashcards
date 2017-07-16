require 'flashcards'
require 'flashcards/language'

describe 'Subjunctivo futuro' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish._verb('hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.subjuntivo_futuro.infinitive).to eql('hablar')
      # expect(hablar.subjuntivo_futuro.root).to eql('habl') # TODO: is it called root or stem?

      expect(hablar.subjuntivo_futuro.irregular?(:yo)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:tú)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:vos)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:él)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:ella)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:usted)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:nosotros)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:nosotras)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:vosotros)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:vosotras)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:ellos)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:ellas)).to be(false)
      expect(hablar.subjuntivo_futuro.irregular?(:ustedes)).to be(false)

      expect(hablar.subjuntivo_futuro.yo).to eql('hablare')
      expect(hablar.subjuntivo_futuro.tú).to eql('hablares')
      expect(hablar.subjuntivo_futuro.vos).to eql(hablar.subjuntivo_futuro.tú)
      expect(hablar.subjuntivo_futuro.él).to eql('hablare')
      expect(hablar.subjuntivo_futuro.ella).to eql(hablar.subjuntivo_futuro.él)
      expect(hablar.subjuntivo_futuro.usted).to eql(hablar.subjuntivo_futuro.él)

      expect(hablar.subjuntivo_futuro.nosotros).to eql('hablaremos')
      expect(hablar.subjuntivo_futuro.nosotras).to eql(hablar.subjuntivo_futuro.nosotros)
      expect(hablar.subjuntivo_futuro.vosotros).to eql('hablareis')
      expect(hablar.subjuntivo_futuro.vosotras).to eql(hablar.subjuntivo_futuro.vosotros)
      expect(hablar.subjuntivo_futuro.ellos).to eql('hablaren')
      expect(hablar.subjuntivo_futuro.ellas).to eql(hablar.subjuntivo_futuro.ellos)
      expect(hablar.subjuntivo_futuro.ustedes).to eql(hablar.subjuntivo_futuro.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish._verb('comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.subjuntivo_futuro.infinitive).to eql('comer')
      # expect(comer.subjuntivo_futuro.root).to eql('com') # TODO: is it called root or stem?

      expect(comer.subjuntivo_futuro.irregular?(:yo)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:tú)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:vos)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:él)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:ella)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:usted)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:nosotros)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:nosotras)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:vosotros)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:vosotras)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:ellos)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:ellas)).to be(false)
      expect(comer.subjuntivo_futuro.irregular?(:ustedes)).to be(false)

      expect(comer.subjuntivo_futuro.yo).to eql('comiere')
      expect(comer.subjuntivo_futuro.tú).to eql('comieres')
      expect(comer.subjuntivo_futuro.vos).to eql(comer.subjuntivo_futuro.tú)
      expect(comer.subjuntivo_futuro.él).to eql('comiere')
      expect(comer.subjuntivo_futuro.ella).to eql(comer.subjuntivo_futuro.él)
      expect(comer.subjuntivo_futuro.usted).to eql(comer.subjuntivo_futuro.él)

      expect(comer.subjuntivo_futuro.nosotros).to eql('comieremos')
      expect(comer.subjuntivo_futuro.nosotras).to eql(comer.subjuntivo_futuro.nosotros)
      expect(comer.subjuntivo_futuro.vosotros).to eql('comiereis')
      expect(comer.subjuntivo_futuro.vosotras).to eql(comer.subjuntivo_futuro.vosotros)
      expect(comer.subjuntivo_futuro.ellos).to eql('comieren')
      expect(comer.subjuntivo_futuro.ellas).to eql(comer.subjuntivo_futuro.ellos)
      expect(comer.subjuntivo_futuro.ustedes).to eql(comer.subjuntivo_futuro.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish._verb('vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.subjuntivo_futuro.infinitive).to eql('vivir')
      # expect(vivir.subjuntivo_futuro.root).to eql('viv') # TODO: is it called root or stem?

      expect(vivir.subjuntivo_futuro.irregular?(:yo)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:tú)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:vos)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:él)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:ella)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:usted)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:nosotros)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:nosotras)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:vosotros)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:vosotras)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:ellos)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:ellas)).to be(false)
      expect(vivir.subjuntivo_futuro.irregular?(:ustedes)).to be(false)

      expect(vivir.subjuntivo_futuro.yo).to eql('viviere')
      expect(vivir.subjuntivo_futuro.tú).to eql('vivieres')
      expect(vivir.subjuntivo_futuro.vos).to eql(vivir.subjuntivo_futuro.tú)
      expect(vivir.subjuntivo_futuro.él).to eql('viviere')
      expect(vivir.subjuntivo_futuro.ella).to eql(vivir.subjuntivo_futuro.él)
      expect(vivir.subjuntivo_futuro.usted).to eql(vivir.subjuntivo_futuro.él)

      expect(vivir.subjuntivo_futuro.nosotros).to eql('vivieremos')
      expect(vivir.subjuntivo_futuro.nosotras).to eql(vivir.subjuntivo_futuro.nosotros)
      expect(vivir.subjuntivo_futuro.vosotros).to eql('viviereis')
      expect(vivir.subjuntivo_futuro.vosotras).to eql(vivir.subjuntivo_futuro.vosotros)
      expect(vivir.subjuntivo_futuro.ellos).to eql('vivieren')
      expect(vivir.subjuntivo_futuro.ellas).to eql(vivir.subjuntivo_futuro.ellos)
      expect(vivir.subjuntivo_futuro.ustedes).to eql(vivir.subjuntivo_futuro.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse').subjuntivo_futuro.él).to eql(spanish._verb('hablar').subjuntivo_futuro.él)
    expect(spanish._verb('comerse').subjuntivo_futuro.él).to eql(spanish._verb('comer').subjuntivo_futuro.él)
    expect(spanish._verb('vivirse').subjuntivo_futuro.él).to eql(spanish._verb('vivir').subjuntivo_futuro.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
