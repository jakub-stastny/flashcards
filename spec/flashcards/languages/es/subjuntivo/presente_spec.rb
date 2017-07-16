require 'flashcards'
require 'flashcards/language'

describe 'Subjunctivo' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish._verb('hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.subjunctivo.infinitive).to eql('hablar')
      expect(hablar.subjunctivo.root).to eql('habl') # TODO: is it called root or stem?

      expect(hablar.subjunctivo.irregular?(:yo)).to be(false)
      expect(hablar.subjunctivo.irregular?(:tú)).to be(false)
      expect(hablar.subjunctivo.irregular?(:vos)).to be(false)
      expect(hablar.subjunctivo.irregular?(:él)).to be(false)
      expect(hablar.subjunctivo.irregular?(:ella)).to be(false)
      expect(hablar.subjunctivo.irregular?(:usted)).to be(false)
      expect(hablar.subjunctivo.irregular?(:nosotros)).to be(false)
      expect(hablar.subjunctivo.irregular?(:nosotras)).to be(false)
      expect(hablar.subjunctivo.irregular?(:vosotros)).to be(false)
      expect(hablar.subjunctivo.irregular?(:vosotras)).to be(false)
      expect(hablar.subjunctivo.irregular?(:ellos)).to be(false)
      expect(hablar.subjunctivo.irregular?(:ellas)).to be(false)
      expect(hablar.subjunctivo.irregular?(:ustedes)).to be(false)

      expect(hablar.subjunctivo.yo).to eql('hable')
      expect(hablar.subjunctivo.tú).to eql('hables')
      expect(hablar.subjunctivo.vos).to eql(hablar.subjunctivo.tú)
      expect(hablar.subjunctivo.él).to eql('hable')
      expect(hablar.subjunctivo.ella).to eql(hablar.subjunctivo.él)
      expect(hablar.subjunctivo.usted).to eql(hablar.subjunctivo.él)

      expect(hablar.subjunctivo.nosotros).to eql('hablemos')
      expect(hablar.subjunctivo.nosotras).to eql(hablar.subjunctivo.nosotros)
      expect(hablar.subjunctivo.vosotros).to eql('habléis')
      expect(hablar.subjunctivo.vosotras).to eql(hablar.subjunctivo.vosotros)
      expect(hablar.subjunctivo.ellos).to eql('hablen')
      expect(hablar.subjunctivo.ellas).to eql(hablar.subjunctivo.ellos)
      expect(hablar.subjunctivo.ustedes).to eql(hablar.subjunctivo.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish._verb('comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.subjunctivo.infinitive).to eql('comer')
      expect(comer.subjunctivo.root).to eql('com') # TODO: is it called root or stem?

      expect(comer.subjunctivo.irregular?(:yo)).to be(false)
      expect(comer.subjunctivo.irregular?(:tú)).to be(false)
      expect(comer.subjunctivo.irregular?(:vos)).to be(false)
      expect(comer.subjunctivo.irregular?(:él)).to be(false)
      expect(comer.subjunctivo.irregular?(:ella)).to be(false)
      expect(comer.subjunctivo.irregular?(:usted)).to be(false)
      expect(comer.subjunctivo.irregular?(:nosotros)).to be(false)
      expect(comer.subjunctivo.irregular?(:nosotras)).to be(false)
      expect(comer.subjunctivo.irregular?(:vosotros)).to be(false)
      expect(comer.subjunctivo.irregular?(:vosotras)).to be(false)
      expect(comer.subjunctivo.irregular?(:ellos)).to be(false)
      expect(comer.subjunctivo.irregular?(:ellas)).to be(false)
      expect(comer.subjunctivo.irregular?(:ustedes)).to be(false)

      expect(comer.subjunctivo.yo).to eql('coma')
      expect(comer.subjunctivo.tú).to eql('comas')
      expect(comer.subjunctivo.vos).to eql(comer.subjunctivo.tú)
      expect(comer.subjunctivo.él).to eql('coma')
      expect(comer.subjunctivo.ella).to eql(comer.subjunctivo.él)
      expect(comer.subjunctivo.usted).to eql(comer.subjunctivo.él)

      expect(comer.subjunctivo.nosotros).to eql('comamos')
      expect(comer.subjunctivo.nosotras).to eql(comer.subjunctivo.nosotros)
      expect(comer.subjunctivo.vosotros).to eql('comáis')
      expect(comer.subjunctivo.vosotras).to eql(comer.subjunctivo.vosotros)
      expect(comer.subjunctivo.ellos).to eql('coman')
      expect(comer.subjunctivo.ellas).to eql(comer.subjunctivo.ellos)
      expect(comer.subjunctivo.ustedes).to eql(comer.subjunctivo.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish._verb('vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.subjunctivo.infinitive).to eql('vivir')
      expect(vivir.subjunctivo.root).to eql('viv') # TODO: is it called root or stem?

      expect(vivir.subjunctivo.irregular?(:yo)).to be(false)
      expect(vivir.subjunctivo.irregular?(:tú)).to be(false)
      expect(vivir.subjunctivo.irregular?(:vos)).to be(false)
      expect(vivir.subjunctivo.irregular?(:él)).to be(false)
      expect(vivir.subjunctivo.irregular?(:ella)).to be(false)
      expect(vivir.subjunctivo.irregular?(:usted)).to be(false)
      expect(vivir.subjunctivo.irregular?(:nosotros)).to be(false)
      expect(vivir.subjunctivo.irregular?(:nosotras)).to be(false)
      expect(vivir.subjunctivo.irregular?(:vosotros)).to be(false)
      expect(vivir.subjunctivo.irregular?(:vosotras)).to be(false)
      expect(vivir.subjunctivo.irregular?(:ellos)).to be(false)
      expect(vivir.subjunctivo.irregular?(:ellas)).to be(false)
      expect(vivir.subjunctivo.irregular?(:ustedes)).to be(false)

      expect(vivir.subjunctivo.yo).to eql('viva')
      expect(vivir.subjunctivo.tú).to eql('vivas')
      expect(vivir.subjunctivo.vos).to eql(vivir.subjunctivo.tú)
      expect(vivir.subjunctivo.él).to eql('viva')
      expect(vivir.subjunctivo.ella).to eql(vivir.subjunctivo.él)
      expect(vivir.subjunctivo.usted).to eql(vivir.subjunctivo.él)

      expect(vivir.subjunctivo.nosotros).to eql('vivamos')
      expect(vivir.subjunctivo.nosotras).to eql(vivir.subjunctivo.nosotros)
      expect(vivir.subjunctivo.vosotros).to eql('viváis')
      expect(vivir.subjunctivo.vosotras).to eql(vivir.subjunctivo.vosotros)
      expect(vivir.subjunctivo.ellos).to eql('vivan')
      expect(vivir.subjunctivo.ellas).to eql(vivir.subjunctivo.ellos)
      expect(vivir.subjunctivo.ustedes).to eql(vivir.subjunctivo.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse').subjunctivo.él).to eql(spanish._verb('hablar').subjunctivo.él)
    expect(spanish._verb('comerse').subjunctivo.él).to eql(spanish._verb('comer').subjunctivo.él)
    expect(spanish._verb('vivirse').subjunctivo.él).to eql(spanish._verb('vivir').subjunctivo.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
