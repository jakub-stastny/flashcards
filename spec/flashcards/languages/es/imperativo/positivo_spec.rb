require 'flashcards'
require 'flashcards/language'

describe 'Affirmative informal commands' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.verb('hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.imperativo_positivo.infinitive).to eql('hablar')
      expect(hablar.imperativo_positivo.root).to eql('habl') # TODO: is it called root or stem?

      expect(hablar.imperativo_positivo.irregular?(:tú)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:vos)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:nosotros)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:nosotras)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:vosotros)).to be(false)
      expect(hablar.imperativo_positivo.irregular?(:vosotras)).to be(false)

      expect(hablar.imperativo_positivo.tú).to eql('habla')
      expect(hablar.imperativo_positivo.vos).to eql('hablá')

      expect(hablar.imperativo_positivo.nosotros).to eql('hablemos')
      expect(hablar.imperativo_positivo.nosotras).to eql(hablar.imperativo_positivo.nosotros)
      expect(hablar.imperativo_positivo.vosotros).to eql('hablad')
      expect(hablar.imperativo_positivo.vosotras).to eql(hablar.imperativo_positivo.vosotros)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.verb('comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.imperativo_positivo.infinitive).to eql('comer')
      expect(comer.imperativo_positivo.root).to eql('com') # TODO: is it called root or stem?

      expect(comer.imperativo_positivo.irregular?(:tú)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:vos)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:nosotros)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:nosotras)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:vosotros)).to be(false)
      expect(comer.imperativo_positivo.irregular?(:vosotras)).to be(false)

      expect(comer.imperativo_positivo.tú).to eql('come')
      expect(comer.imperativo_positivo.vos).to eql('comé')

      expect(comer.imperativo_positivo.nosotros).to eql('comamos')
      expect(comer.imperativo_positivo.nosotras).to eql(comer.imperativo_positivo.nosotros)
      expect(comer.imperativo_positivo.vosotros).to eql('comed')
      expect(comer.imperativo_positivo.vosotras).to eql(comer.imperativo_positivo.vosotros)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.verb('vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.imperativo_positivo.infinitive).to eql('vivir')
      expect(vivir.imperativo_positivo.root).to eql('viv') # TODO: is it called root or stem?

      expect(vivir.imperativo_positivo.irregular?(:tú)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:vos)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:nosotros)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:nosotras)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:vosotros)).to be(false)
      expect(vivir.imperativo_positivo.irregular?(:vosotras)).to be(false)

      expect(vivir.imperativo_positivo.tú).to eql('vive')
      expect(vivir.imperativo_positivo.vos).to eql('viví')

      expect(vivir.imperativo_positivo.nosotros).to eql('vivamos')
      expect(vivir.imperativo_positivo.nosotras).to eql(vivir.imperativo_positivo.nosotros)
      expect(vivir.imperativo_positivo.vosotros).to eql('vivid')
      expect(vivir.imperativo_positivo.vosotras).to eql(vivir.imperativo_positivo.vosotros)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.verb('hablarse').imperativo_positivo.tú).to eql(spanish.verb('hablar').imperativo_positivo.tú)
    expect(spanish.verb('comerse').imperativo_positivo.tú).to eql(spanish.verb('comer').imperativo_positivo.tú)
    expect(spanish.verb('vivirse').imperativo_positivo.tú).to eql(spanish.verb('vivir').imperativo_positivo.tú)
  end

  # TODO: How about ir? What's the stem of voy?
end
