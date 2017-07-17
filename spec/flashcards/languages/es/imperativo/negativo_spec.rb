require 'flashcards'
require 'flashcards/language'

describe 'Negative informal commands' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish._verb('hablar', Hash.new) }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.imperativo_negativo.infinitive).to eql('hablar')
      expect(hablar.imperativo_negativo.root).to eql('habl') # TODO: is it called root or stem?

      expect(hablar.imperativo_negativo.irregular?(:tú)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:vos)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:nosotros)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:nosotras)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:vosotros)).to be(false)
      expect(hablar.imperativo_negativo.irregular?(:vosotras)).to be(false)

      expect(hablar.imperativo_negativo.tú).to eql('hables')
      expect(hablar.imperativo_negativo.vos).to eql(hablar.imperativo_negativo.tú) # Is it?

      expect(hablar.imperativo_negativo.nosotros).to eql('hablemos')
      expect(hablar.imperativo_negativo.nosotras).to eql(hablar.imperativo_negativo.nosotros)
      expect(hablar.imperativo_negativo.vosotros).to eql('habléis')
      expect(hablar.imperativo_negativo.vosotras).to eql(hablar.imperativo_negativo.vosotros)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish._verb('comer', Hash.new) }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.imperativo_negativo.infinitive).to eql('comer')
      expect(comer.imperativo_negativo.root).to eql('com') # TODO: is it called root or stem?

      expect(comer.imperativo_negativo.irregular?(:tú)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:vos)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:nosotros)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:nosotras)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:vosotros)).to be(false)
      expect(comer.imperativo_negativo.irregular?(:vosotras)).to be(false)

      expect(comer.imperativo_negativo.tú).to eql('comas')
      expect(comer.imperativo_negativo.vos).to eql(comer.imperativo_negativo.tú) # Is it?

      expect(comer.imperativo_negativo.nosotros).to eql('comamos')
      expect(comer.imperativo_negativo.nosotras).to eql(comer.imperativo_negativo.nosotros)
      expect(comer.imperativo_negativo.vosotros).to eql('comáis')
      expect(comer.imperativo_negativo.vosotras).to eql(comer.imperativo_negativo.vosotros)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish._verb('vivir', Hash.new) }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.imperativo_negativo.infinitive).to eql('vivir')
      expect(vivir.imperativo_negativo.root).to eql('viv') # TODO: is it called root or stem?

      expect(vivir.imperativo_negativo.irregular?(:tú)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:vos)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:nosotros)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:nosotras)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:vosotros)).to be(false)
      expect(vivir.imperativo_negativo.irregular?(:vosotras)).to be(false)

      expect(vivir.imperativo_negativo.tú).to eql('vivas')
      expect(vivir.imperativo_negativo.vos).to eql(vivir.imperativo_negativo.tú) # Is it?

      expect(vivir.imperativo_negativo.nosotros).to eql('vivamos')
      expect(vivir.imperativo_negativo.nosotras).to eql(vivir.imperativo_negativo.nosotros)
      expect(vivir.imperativo_negativo.vosotros).to eql('viváis')
      expect(vivir.imperativo_negativo.vosotras).to eql(vivir.imperativo_negativo.vosotros)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish._verb('hablarse', Hash.new).imperativo_negativo.tú).to eql(spanish._verb('hablar', Hash.new).imperativo_negativo.tú)
    expect(spanish._verb('comerse', Hash.new).imperativo_negativo.tú).to eql(spanish._verb('comer', Hash.new).imperativo_negativo.tú)
    expect(spanish._verb('vivirse', Hash.new).imperativo_negativo.tú).to eql(spanish._verb('vivir', Hash.new).imperativo_negativo.tú)
  end

  # TODO: How about ir? What's the stem of voy?
end
