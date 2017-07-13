require 'flashcards'
require 'flashcards/language'

describe 'Pretérito' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.verb('hablar') }

    it 'is regular' do
      expect(hablar.infinitive).to eql('hablar')
      expect(hablar.pretérito.infinitive).to eql('hablar')
      expect(hablar.pretérito.root).to eql('habl') # TODO: is it called root or stem?

      expect(hablar.pretérito.irregular?(:yo)).to be(false)
      expect(hablar.pretérito.irregular?(:tú)).to be(false)
      expect(hablar.pretérito.irregular?(:vos)).to be(false)
      expect(hablar.pretérito.irregular?(:él)).to be(false)
      expect(hablar.pretérito.irregular?(:ella)).to be(false)
      expect(hablar.pretérito.irregular?(:usted)).to be(false)
      expect(hablar.pretérito.irregular?(:nosotros)).to be(false)
      expect(hablar.pretérito.irregular?(:nosotras)).to be(false)
      expect(hablar.pretérito.irregular?(:vosotros)).to be(false)
      expect(hablar.pretérito.irregular?(:vosotras)).to be(false)
      expect(hablar.pretérito.irregular?(:ellos)).to be(false)
      expect(hablar.pretérito.irregular?(:ellas)).to be(false)
      expect(hablar.pretérito.irregular?(:ustedes)).to be(false)

      expect(hablar.pretérito.yo).to eql('hablé')
      expect(hablar.pretérito.tú).to eql('hablaste')
      expect(hablar.pretérito.vos).to eql(hablar.pretérito.tú)
      expect(hablar.pretérito.él).to eql('habló')
      expect(hablar.pretérito.ella).to eql(hablar.pretérito.él)
      expect(hablar.pretérito.usted).to eql(hablar.pretérito.él)

      expect(hablar.pretérito.nosotros).to eql('hablamos')
      expect(hablar.pretérito.nosotras).to eql(hablar.pretérito.nosotros)
      expect(hablar.pretérito.vosotros).to eql('hablasteis')
      expect(hablar.pretérito.vosotras).to eql(hablar.pretérito.vosotros)
      expect(hablar.pretérito.ellos).to eql('hablaron')
      expect(hablar.pretérito.ellas).to eql(hablar.pretérito.ellos)
      expect(hablar.pretérito.ustedes).to eql(hablar.pretérito.ellos)
    end
  end

  describe 'verbs ending with -car' do
    let(:buscar) { spanish.verb('buscar') }

    it 'changes c -> qu in the first person only' do
      expect(buscar.infinitive).to eql('buscar')
      expect(buscar.pretérito.infinitive).to eql('buscar')
      expect(buscar.pretérito.root).to eql('busc') # TODO: is it called root or stem?

      expect(buscar.pretérito.irregular?(:yo)).to be(true)
      expect(buscar.pretérito.irregular?(:tú)).to be(false)
      expect(buscar.pretérito.irregular?(:vos)).to be(false)
      expect(buscar.pretérito.irregular?(:él)).to be(false)
      expect(buscar.pretérito.irregular?(:ella)).to be(false)
      expect(buscar.pretérito.irregular?(:usted)).to be(false)
      expect(buscar.pretérito.irregular?(:nosotros)).to be(false)
      expect(buscar.pretérito.irregular?(:nosotras)).to be(false)
      expect(buscar.pretérito.irregular?(:vosotros)).to be(false)
      expect(buscar.pretérito.irregular?(:vosotras)).to be(false)
      expect(buscar.pretérito.irregular?(:ellos)).to be(false)
      expect(buscar.pretérito.irregular?(:ellas)).to be(false)
      expect(buscar.pretérito.irregular?(:ustedes)).to be(false)

      expect(buscar.pretérito.yo).to eql('busqué')
      expect(buscar.pretérito.tú).to eql('buscaste')
      expect(buscar.pretérito.vos).to eql(buscar.pretérito.tú)
      expect(buscar.pretérito.él).to eql('buscó')
      expect(buscar.pretérito.ella).to eql(buscar.pretérito.él)
      expect(buscar.pretérito.usted).to eql(buscar.pretérito.él)

      expect(buscar.pretérito.nosotros).to eql('buscamos')
      expect(buscar.pretérito.nosotras).to eql(buscar.pretérito.nosotros)
      expect(buscar.pretérito.vosotros).to eql('buscasteis')
      expect(buscar.pretérito.vosotras).to eql(buscar.pretérito.vosotros)
      expect(buscar.pretérito.ellos).to eql('buscaron')
      expect(buscar.pretérito.ellas).to eql(buscar.pretérito.ellos)
      expect(buscar.pretérito.ustedes).to eql(buscar.pretérito.ellos)
    end
  end

  describe 'verbs ending with -gar' do
    let(:pagar) { spanish.verb('pagar') }

    it 'changes c -> gu in the first person only' do
      expect(pagar.infinitive).to eql('pagar')
      expect(pagar.pretérito.infinitive).to eql('pagar')
      expect(pagar.pretérito.root).to eql('pag') # TODO: is it called root or stem?

      expect(pagar.pretérito.irregular?(:yo)).to be(true)
      expect(pagar.pretérito.irregular?(:tú)).to be(false)
      expect(pagar.pretérito.irregular?(:vos)).to be(false)
      expect(pagar.pretérito.irregular?(:él)).to be(false)
      expect(pagar.pretérito.irregular?(:ella)).to be(false)
      expect(pagar.pretérito.irregular?(:usted)).to be(false)
      expect(pagar.pretérito.irregular?(:nosotros)).to be(false)
      expect(pagar.pretérito.irregular?(:nosotras)).to be(false)
      expect(pagar.pretérito.irregular?(:vosotros)).to be(false)
      expect(pagar.pretérito.irregular?(:vosotras)).to be(false)
      expect(pagar.pretérito.irregular?(:ellos)).to be(false)
      expect(pagar.pretérito.irregular?(:ellas)).to be(false)
      expect(pagar.pretérito.irregular?(:ustedes)).to be(false)

      expect(pagar.pretérito.yo).to eql('pagué')
      expect(pagar.pretérito.tú).to eql('pagaste')
      expect(pagar.pretérito.vos).to eql(pagar.pretérito.tú)
      expect(pagar.pretérito.él).to eql('pagó')
      expect(pagar.pretérito.ella).to eql(pagar.pretérito.él)
      expect(pagar.pretérito.usted).to eql(pagar.pretérito.él)

      expect(pagar.pretérito.nosotros).to eql('pagamos')
      expect(pagar.pretérito.nosotras).to eql(pagar.pretérito.nosotros)
      expect(pagar.pretérito.vosotros).to eql('pagasteis')
      expect(pagar.pretérito.vosotras).to eql(pagar.pretérito.vosotros)
      expect(pagar.pretérito.ellos).to eql('pagaron')
      expect(pagar.pretérito.ustedes).to eql('pagaron')
      expect(pagar.pretérito.ellas).to eql(pagar.pretérito.ellos)
      expect(pagar.pretérito.ustedes).to eql(pagar.pretérito.ellos)
    end
  end

  describe 'verbs ending with -zar' do
    let(:realizar) { spanish.verb('realizar') }

    it 'changes c -> c in the first person only' do
      expect(realizar.infinitive).to eql('realizar')
      expect(realizar.pretérito.infinitive).to eql('realizar')
      expect(realizar.pretérito.root).to eql('realiz') # TODO: is it called root or stem?

      expect(realizar.pretérito.irregular?(:yo)).to be(true)
      expect(realizar.pretérito.irregular?(:tú)).to be(false)
      expect(realizar.pretérito.irregular?(:vos)).to be(false)
      expect(realizar.pretérito.irregular?(:él)).to be(false)
      expect(realizar.pretérito.irregular?(:ella)).to be(false)
      expect(realizar.pretérito.irregular?(:usted)).to be(false)
      expect(realizar.pretérito.irregular?(:nosotros)).to be(false)
      expect(realizar.pretérito.irregular?(:nosotras)).to be(false)
      expect(realizar.pretérito.irregular?(:vosotros)).to be(false)
      expect(realizar.pretérito.irregular?(:vosotras)).to be(false)
      expect(realizar.pretérito.irregular?(:ellos)).to be(false)
      expect(realizar.pretérito.irregular?(:ellas)).to be(false)
      expect(realizar.pretérito.irregular?(:ustedes)).to be(false)

      expect(realizar.pretérito.yo).to eql('realicé')
      expect(realizar.pretérito.tú).to eql('realizaste')
      expect(realizar.pretérito.vos).to eql(realizar.pretérito.tú)
      expect(realizar.pretérito.él).to eql('realizó')
      expect(realizar.pretérito.ella).to eql(realizar.pretérito.él)
      expect(realizar.pretérito.usted).to eql(realizar.pretérito.él)

      expect(realizar.pretérito.nosotros).to eql('realizamos')
      expect(realizar.pretérito.nosotras).to eql(realizar.pretérito.nosotros)
      expect(realizar.pretérito.vosotros).to eql('realizasteis')
      expect(realizar.pretérito.vosotras).to eql(realizar.pretérito.vosotros)
      expect(realizar.pretérito.ellos).to eql('realizaron')
      expect(realizar.pretérito.ellas).to eql(realizar.pretérito.ellos)
      expect(realizar.pretérito.ustedes).to eql(realizar.pretérito.ellos)
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.verb('comer') }

    it 'is regular' do
      expect(comer.infinitive).to eql('comer')
      expect(comer.pretérito.infinitive).to eql('comer')
      expect(comer.pretérito.root).to eql('com') # TODO: is it called root or stem?

      expect(comer.pretérito.irregular?(:yo)).to be(false)
      expect(comer.pretérito.irregular?(:tú)).to be(false)
      expect(comer.pretérito.irregular?(:vos)).to be(false)
      expect(comer.pretérito.irregular?(:él)).to be(false)
      expect(comer.pretérito.irregular?(:ella)).to be(false)
      expect(comer.pretérito.irregular?(:usted)).to be(false)
      expect(comer.pretérito.irregular?(:nosotros)).to be(false)
      expect(comer.pretérito.irregular?(:nosotras)).to be(false)
      expect(comer.pretérito.irregular?(:vosotros)).to be(false)
      expect(comer.pretérito.irregular?(:vosotras)).to be(false)
      expect(comer.pretérito.irregular?(:ellos)).to be(false)
      expect(comer.pretérito.irregular?(:ellas)).to be(false)
      expect(comer.pretérito.irregular?(:ustedes)).to be(false)

      expect(comer.pretérito.yo).to eql('comí')
      expect(comer.pretérito.tú).to eql('comiste')
      expect(comer.pretérito.vos).to eql(comer.pretérito.tú)
      expect(comer.pretérito.él).to eql('comió')
      expect(comer.pretérito.ella).to eql(comer.pretérito.él)
      expect(comer.pretérito.usted).to eql(comer.pretérito.él)

      expect(comer.pretérito.nosotros).to eql('comimos')
      expect(comer.pretérito.nosotras).to eql(comer.pretérito.nosotros)
      expect(comer.pretérito.vosotros).to eql('comisteis')
      expect(comer.pretérito.vosotras).to eql(comer.pretérito.vosotros)
      expect(comer.pretérito.ellos).to eql('comieron')
      expect(comer.pretérito.ellas).to eql(comer.pretérito.ellos)
      expect(comer.pretérito.ustedes).to eql(comer.pretérito.ellos)
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.verb('vivir') }

    it 'is regular' do
      expect(vivir.infinitive).to eql('vivir')
      expect(vivir.pretérito.infinitive).to eql('vivir')
      expect(vivir.pretérito.root).to eql('viv') # TODO: is it called root or stem?

      expect(vivir.pretérito.irregular?(:yo)).to be(false)
      expect(vivir.pretérito.irregular?(:tú)).to be(false)
      expect(vivir.pretérito.irregular?(:vos)).to be(false)
      expect(vivir.pretérito.irregular?(:él)).to be(false)
      expect(vivir.pretérito.irregular?(:ella)).to be(false)
      expect(vivir.pretérito.irregular?(:usted)).to be(false)
      expect(vivir.pretérito.irregular?(:nosotros)).to be(false)
      expect(vivir.pretérito.irregular?(:nosotras)).to be(false)
      expect(vivir.pretérito.irregular?(:vosotros)).to be(false)
      expect(vivir.pretérito.irregular?(:vosotras)).to be(false)
      expect(vivir.pretérito.irregular?(:ellos)).to be(false)
      expect(vivir.pretérito.irregular?(:ellas)).to be(false)
      expect(vivir.pretérito.irregular?(:ustedes)).to be(false)

      expect(vivir.pretérito.yo).to eql('viví')
      expect(vivir.pretérito.tú).to eql('viviste')
      expect(vivir.pretérito.vos).to eql(vivir.pretérito.tú)
      expect(vivir.pretérito.él).to eql('vivió')
      expect(vivir.pretérito.ella).to eql(vivir.pretérito.él)
      expect(vivir.pretérito.usted).to eql(vivir.pretérito.él)

      expect(vivir.pretérito.nosotros).to eql('vivimos')
      expect(vivir.pretérito.nosotras).to eql(vivir.pretérito.nosotros)
      expect(vivir.pretérito.vosotros).to eql('vivisteis')
      expect(vivir.pretérito.vosotras).to eql(vivir.pretérito.vosotros)
      expect(vivir.pretérito.ellos).to eql('vivieron')
      expect(vivir.pretérito.ellas).to eql(vivir.pretérito.ellos)
      expect(vivir.pretérito.ustedes).to eql(vivir.pretérito.ellos)
    end
  end

  # TODO: This should return "se vive" etc rather than just "vive".
  it 'handles reflective verbs' do
    expect(spanish.verb('hablarse').pretérito.él).to eql(spanish.verb('hablar').pretérito.él)
    expect(spanish.verb('comerse').pretérito.él).to eql(spanish.verb('comer').pretérito.él)
    expect(spanish.verb('vivirse').pretérito.él).to eql(spanish.verb('vivir').pretérito.él)
  end

  # TODO: How about ir? What's the stem of voy?
end
