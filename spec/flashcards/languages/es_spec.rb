require 'flashcards'
require 'flashcards/language'

describe 'Present tense' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.verb('hablar') }

    it 'is regular' do
      expect(hablar.present.yo).to eql('hablo')
      expect(hablar.present.tú).to eql('hablas')
      expect(hablar.present.él).to eql('habla')
      expect(hablar.present.usted).to eql('habla')

      expect(hablar.present.nosotros).to eql('hablamos')
      expect(hablar.present.vosotros).to eql('habláis')
      expect(hablar.present.ellos).to eql('hablan')
      expect(hablar.present.ustedes).to eql('hablan')
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.verb('comer') }

    it 'is regular' do
      expect(comer.present.yo).to eql('como')
      expect(comer.present.tú).to eql('comes')
      expect(comer.present.él).to eql('come')
      expect(comer.present.usted).to eql('come')

      expect(comer.present.nosotros).to eql('comemos')
      expect(comer.present.vosotros).to eql('coméis')
      expect(comer.present.ellos).to eql('comen')
      expect(comer.present.ustedes).to eql('comen')
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.verb('vivir') }

    it 'is regular' do
      expect(vivir.present.yo).to eql('vivo')
      expect(vivir.present.tú).to eql('vives')
      expect(vivir.present.él).to eql('vive')
      expect(vivir.present.usted).to eql('vive')

      expect(vivir.present.nosotros).to eql('vivimos')
      expect(vivir.present.vosotros).to eql('vivís')
      expect(vivir.present.ellos).to eql('viven')
      expect(vivir.present.ustedes).to eql('viven')
    end
  end

  describe 'dar' do
    let(:dar) { spanish.verb('dar') }

    it 'is irregular in the first form of singular and second form of plural' do
      expect(dar.present.yo).to eql('doy')
      expect(dar.present.tú).to eql('das')
      expect(dar.present.él).to eql('da')
      expect(dar.present.usted).to eql('da')

      expect(dar.present.nosotros).to eql('damos')
      expect(dar.present.vosotros).to eql('dais')
      expect(dar.present.ellos).to eql('dan')
      expect(dar.present.ustedes).to eql('dan')
    end
  end
end

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
    let(:dar) { spanish.verb('dar') }

    it 'loses accent in the first and third person of singular and is conjugated such as -er/-ir verbs.' do
      expect(dar.pretérito.exception?(:yo)).to be(true)
      expect(dar.pretérito.exception?(:él)).to be(true)

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
