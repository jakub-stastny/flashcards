require 'flashcards'
require 'flashcards/language'

describe 'Subjunctivo' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish._verb('hablar', Hash.new) }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.subjuntivo.infinitive).to eql('hablar')
      expect(hablar.subjuntivo.root).to eql('habl') # TODO: is it called root or stem?

      expect(hablar.subjuntivo.irregular?(:yo)).to be(false)
      expect(hablar.subjuntivo.irregular?(:tú)).to be(false)
      expect(hablar.subjuntivo.irregular?(:vos)).to be(false)
      expect(hablar.subjuntivo.irregular?(:él)).to be(false)
      expect(hablar.subjuntivo.irregular?(:ella)).to be(false)
      expect(hablar.subjuntivo.irregular?(:usted)).to be(false)
      expect(hablar.subjuntivo.irregular?(:nosotros)).to be(false)
      expect(hablar.subjuntivo.irregular?(:nosotras)).to be(false)
      expect(hablar.subjuntivo.irregular?(:vosotros)).to be(false)
      expect(hablar.subjuntivo.irregular?(:vosotras)).to be(false)
      expect(hablar.subjuntivo.irregular?(:ellos)).to be(false)
      expect(hablar.subjuntivo.irregular?(:ellas)).to be(false)
      expect(hablar.subjuntivo.irregular?(:ustedes)).to be(false)

      expect(hablar.subjuntivo.yo).to eql('hable')
      expect(hablar.subjuntivo.tú).to eql('hables')
      expect(hablar.subjuntivo.vos).to eql(hablar.subjuntivo.tú)
      expect(hablar.subjuntivo.él).to eql('hable')
      expect(hablar.subjuntivo.ella).to eql(hablar.subjuntivo.él)
      expect(hablar.subjuntivo.usted).to eql(hablar.subjuntivo.él)

      expect(hablar.subjuntivo.nosotros).to eql('hablemos')
      expect(hablar.subjuntivo.nosotras).to eql(hablar.subjuntivo.nosotros)
      expect(hablar.subjuntivo.vosotros).to eql('habléis')
      expect(hablar.subjuntivo.vosotras).to eql(hablar.subjuntivo.vosotros)
      expect(hablar.subjuntivo.ellos).to eql('hablen')
      expect(hablar.subjuntivo.ellas).to eql(hablar.subjuntivo.ellos)
      expect(hablar.subjuntivo.ustedes).to eql(hablar.subjuntivo.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish._verb('comer', Hash.new) }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.subjuntivo.infinitive).to eql('comer')
      expect(comer.subjuntivo.root).to eql('com') # TODO: is it called root or stem?

      expect(comer.subjuntivo.irregular?(:yo)).to be(false)
      expect(comer.subjuntivo.irregular?(:tú)).to be(false)
      expect(comer.subjuntivo.irregular?(:vos)).to be(false)
      expect(comer.subjuntivo.irregular?(:él)).to be(false)
      expect(comer.subjuntivo.irregular?(:ella)).to be(false)
      expect(comer.subjuntivo.irregular?(:usted)).to be(false)
      expect(comer.subjuntivo.irregular?(:nosotros)).to be(false)
      expect(comer.subjuntivo.irregular?(:nosotras)).to be(false)
      expect(comer.subjuntivo.irregular?(:vosotros)).to be(false)
      expect(comer.subjuntivo.irregular?(:vosotras)).to be(false)
      expect(comer.subjuntivo.irregular?(:ellos)).to be(false)
      expect(comer.subjuntivo.irregular?(:ellas)).to be(false)
      expect(comer.subjuntivo.irregular?(:ustedes)).to be(false)

      expect(comer.subjuntivo.yo).to eql('coma')
      expect(comer.subjuntivo.tú).to eql('comas')
      expect(comer.subjuntivo.vos).to eql(comer.subjuntivo.tú)
      expect(comer.subjuntivo.él).to eql('coma')
      expect(comer.subjuntivo.ella).to eql(comer.subjuntivo.él)
      expect(comer.subjuntivo.usted).to eql(comer.subjuntivo.él)

      expect(comer.subjuntivo.nosotros).to eql('comamos')
      expect(comer.subjuntivo.nosotras).to eql(comer.subjuntivo.nosotros)
      expect(comer.subjuntivo.vosotros).to eql('comáis')
      expect(comer.subjuntivo.vosotras).to eql(comer.subjuntivo.vosotros)
      expect(comer.subjuntivo.ellos).to eql('coman')
      expect(comer.subjuntivo.ellas).to eql(comer.subjuntivo.ellos)
      expect(comer.subjuntivo.ustedes).to eql(comer.subjuntivo.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish._verb('vivir', Hash.new) }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.subjuntivo.infinitive).to eql('vivir')
      expect(vivir.subjuntivo.root).to eql('viv') # TODO: is it called root or stem?

      expect(vivir.subjuntivo.irregular?(:yo)).to be(false)
      expect(vivir.subjuntivo.irregular?(:tú)).to be(false)
      expect(vivir.subjuntivo.irregular?(:vos)).to be(false)
      expect(vivir.subjuntivo.irregular?(:él)).to be(false)
      expect(vivir.subjuntivo.irregular?(:ella)).to be(false)
      expect(vivir.subjuntivo.irregular?(:usted)).to be(false)
      expect(vivir.subjuntivo.irregular?(:nosotros)).to be(false)
      expect(vivir.subjuntivo.irregular?(:nosotras)).to be(false)
      expect(vivir.subjuntivo.irregular?(:vosotros)).to be(false)
      expect(vivir.subjuntivo.irregular?(:vosotras)).to be(false)
      expect(vivir.subjuntivo.irregular?(:ellos)).to be(false)
      expect(vivir.subjuntivo.irregular?(:ellas)).to be(false)
      expect(vivir.subjuntivo.irregular?(:ustedes)).to be(false)

      expect(vivir.subjuntivo.yo).to eql('viva')
      expect(vivir.subjuntivo.tú).to eql('vivas')
      expect(vivir.subjuntivo.vos).to eql(vivir.subjuntivo.tú)
      expect(vivir.subjuntivo.él).to eql('viva')
      expect(vivir.subjuntivo.ella).to eql(vivir.subjuntivo.él)
      expect(vivir.subjuntivo.usted).to eql(vivir.subjuntivo.él)

      expect(vivir.subjuntivo.nosotros).to eql('vivamos')
      expect(vivir.subjuntivo.nosotras).to eql(vivir.subjuntivo.nosotros)
      expect(vivir.subjuntivo.vosotros).to eql('viváis')
      expect(vivir.subjuntivo.vosotras).to eql(vivir.subjuntivo.vosotros)
      expect(vivir.subjuntivo.ellos).to eql('vivan')
      expect(vivir.subjuntivo.ellas).to eql(vivir.subjuntivo.ellos)
      expect(vivir.subjuntivo.ustedes).to eql(vivir.subjuntivo.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse', Hash.new).subjuntivo.él).to eql(spanish._verb('hablar', Hash.new).subjuntivo.él)
    expect(spanish._verb('comerse', Hash.new).subjuntivo.él).to eql(spanish._verb('comer', Hash.new).subjuntivo.él)
    expect(spanish._verb('vivirse', Hash.new).subjuntivo.él).to eql(spanish._verb('vivir', Hash.new).subjuntivo.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
