require 'flashcards'
require 'flashcards/language'


describe 'Pretérito' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.verb('hablar') }

    it 'is regular' do
      expect(hablar.pretérito.yo).to eql('hablé')
      expect(hablar.pretérito.tú).to eql('hablaste')
      expect(hablar.pretérito.él).to eql('habló')
      expect(hablar.pretérito.usted).to eql('habló')

      expect(hablar.pretérito.nosotros).to eql('hablamos')
      expect(hablar.pretérito.vosotros).to eql('hablasteis')
      expect(hablar.pretérito.ellos).to eql('hablaron')
      expect(hablar.pretérito.ustedes).to eql('hablaron')
    end
  end

  describe 'verbs ending with -car' do
    let(:buscar) { spanish.verb('buscar') }

    it 'changes c -> qu in the first person only' do
      expect(buscar.pretérito.exception?(:yo)).to be(true)

      expect(buscar.pretérito.yo).to eql('busqué')
      expect(buscar.pretérito.tú).to eql('buscaste')
      expect(buscar.pretérito.él).to eql('buscó')
      expect(buscar.pretérito.usted).to eql('buscó')

      expect(buscar.pretérito.nosotros).to eql('buscamos')
      expect(buscar.pretérito.vosotros).to eql('buscasteis')
      expect(buscar.pretérito.ellos).to eql('buscaron')
      expect(buscar.pretérito.ustedes).to eql('buscaron')
    end
  end

  describe 'verbs ending with -gar' do
    let(:pagar) { spanish.verb('pagar') }

    it 'changes c -> gu in the first person only' do
      expect(pagar.pretérito.exception?(:yo)).to be(true)

      expect(pagar.pretérito.yo).to eql('pagué')
      expect(pagar.pretérito.tú).to eql('pagaste')
      expect(pagar.pretérito.él).to eql('pagó')
      expect(pagar.pretérito.usted).to eql('pagó')

      expect(pagar.pretérito.nosotros).to eql('pagamos')
      expect(pagar.pretérito.vosotros).to eql('pagasteis')
      expect(pagar.pretérito.ellos).to eql('pagaron')
      expect(pagar.pretérito.ustedes).to eql('pagaron')
    end
  end

  describe 'verbs ending with -zar' do
    let(:realizar) { spanish.verb('realizar') }

    it 'changes c -> c in the first person only' do
      expect(realizar.pretérito.exception?(:yo)).to be(true)

      expect(realizar.pretérito.yo).to eql('realicé')
      expect(realizar.pretérito.tú).to eql('realizaste')
      expect(realizar.pretérito.él).to eql('realizó')
      expect(realizar.pretérito.usted).to eql('realizó')

      expect(realizar.pretérito.nosotros).to eql('realizamos')
      expect(realizar.pretérito.vosotros).to eql('realizasteis')
      expect(realizar.pretérito.ellos).to eql('realizaron')
      expect(realizar.pretérito.ustedes).to eql('realizaron')
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.verb('comer') }

    it 'is regular' do
      expect(comer.pretérito.yo).to eql('comí')
      expect(comer.pretérito.tú).to eql('comiste')
      expect(comer.pretérito.él).to eql('comió')
      expect(comer.pretérito.usted).to eql('comió')

      expect(comer.pretérito.nosotros).to eql('comimos')
      expect(comer.pretérito.vosotros).to eql('comisteis')
      expect(comer.pretérito.ellos).to eql('comieron')
      expect(comer.pretérito.ustedes).to eql('comieron')
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.verb('vivir') }

    it 'is regular' do
      expect(vivir.pretérito.yo).to eql('viví')
      expect(vivir.pretérito.tú).to eql('viviste')
      expect(vivir.pretérito.él).to eql('vivió')
      expect(vivir.pretérito.usted).to eql('vivió')

      expect(vivir.pretérito.nosotros).to eql('vivimos')
      expect(vivir.pretérito.vosotros).to eql('vivisteis')
      expect(vivir.pretérito.ellos).to eql('vivieron')
      expect(vivir.pretérito.ustedes).to eql('vivieron')
    end
  end

  describe 'ver' do
    let(:ver) { spanish.verb('ver') }

    it 'loses accent in the first and third person of singular' do
      expect(ver.pretérito.exception?(:yo)).to be(true)
      expect(ver.pretérito.exception?(:él)).to be(true)

      expect(ver.pretérito.yo).to eql('vi')
      expect(ver.pretérito.tú).to eql('viste')
      expect(ver.pretérito.él).to eql('vio')
      expect(ver.pretérito.usted).to eql('vio')

      expect(ver.pretérito.nosotros).to eql('vimos')
      expect(ver.pretérito.vosotros).to eql('visteis')
      expect(ver.pretérito.ellos).to eql('vieron')
      expect(ver.pretérito.ustedes).to eql('vieron')
    end
  end

  describe 'dar' do
    let(:dar) do
      spanish.verb('dar', pretérito: {
        yo: 'di',    nosotros: 'dimos',
        tú: 'diste', vosotros: 'disteis',
        él: 'dio',   ellos:    'dieron'})
    end

    shared_examples do
      expect(dar.pretérito.exception?(:yo)).to be(true)
    end

    it 'loses accent in the first and third person of singular and is conjugated such as -er/-ir verbs.' do
      expect(dar.pretérito.exception?(:yo)).to be(true)
      expect(dar.pretérito.exception?(:tú)).to be(true)
      expect(dar.pretérito.exception?(:vos)).to be(false)
      expect(dar.pretérito.exception?(:él)).to be(true)
      # expect(dar.pretérito.exception?(:usted)).to be(true)
      expect(dar.pretérito.exception?(:nosotros)).to be(true)
      expect(dar.pretérito.exception?(:vosotros)).to be(true)
      expect(dar.pretérito.exception?(:ellos)).to be(true)
      # expect(dar.pretérito.exception?(:ustedes)).to be(true)

      expect(dar.pretérito.yo).to eql('di')
      expect(dar.pretérito.tú).to eql('diste')
      expect(dar.pretérito.él).to eql('dio')
      expect(dar.pretérito.usted).to eql('dio')

      expect(dar.pretérito.nosotros).to eql('dimos')
      expect(dar.pretérito.vosotros).to eql('disteis')
      expect(dar.pretérito.ellos).to eql('dieron')
      expect(dar.pretérito.ustedes).to eql('dieron')
    end
  end
end
