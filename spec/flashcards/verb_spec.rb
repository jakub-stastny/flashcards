require 'flashcards/verb'

describe 'Present tense' do
  describe 'verbs ending with -ar' do
    subject { Verb.new('hablar').present }

    it 'is regular' do
      expect(subject.yo).to eql('hablo')
      expect(subject.tú).to eql('hablas')
      expect(subject.él).to eql('habla')
      expect(subject.usted).to eql('habla')

      expect(subject.nosotros).to eql('hablamos')
      expect(subject.vosotros).to eql('habláis')
      expect(subject.ellos).to eql('hablan')
      expect(subject.ustedes).to eql('hablan')
    end
  end

  describe 'verbs ending with -er' do
    subject { Verb.new('comer').present }

    it 'is regular' do
      expect(subject.yo).to eql('como')
      expect(subject.tú).to eql('comes')
      expect(subject.él).to eql('come')
      expect(subject.usted).to eql('come')

      expect(subject.nosotros).to eql('comemos')
      expect(subject.vosotros).to eql('coméis')
      expect(subject.ellos).to eql('comen')
      expect(subject.ustedes).to eql('comen')
    end
  end

  describe 'verbs ending with -ir' do
    subject { Verb.new('vivir').present }

    it 'is regular' do
      expect(subject.yo).to eql('vivo')
      expect(subject.tú).to eql('vives')
      expect(subject.él).to eql('vive')
      expect(subject.usted).to eql('vive')

      expect(subject.nosotros).to eql('vivimos')
      expect(subject.vosotros).to eql('vivís')
      expect(subject.ellos).to eql('viven')
      expect(subject.ustedes).to eql('viven')
    end
  end
end

describe 'Past tense' do
  describe 'verbs ending with -ar' do
    subject { Verb.new('hablar').past }

    it 'is regular' do
      expect(subject.yo).to eql('hablé')
      expect(subject.tú).to eql('hablaste')
      expect(subject.él).to eql('habló')
      expect(subject.usted).to eql('habló')

      expect(subject.nosotros).to eql('hablamos')
      expect(subject.vosotros).to eql('hablasteis')
      expect(subject.ellos).to eql('hablaron')
      expect(subject.ustedes).to eql('hablaron')
    end
  end

  describe 'verbs ending with -car' do
    subject { Verb.new('buscar').past }

    it 'changes c -> qu in the first person only' do
      expect(subject.exception?(:yo)).to be(true)

      expect(subject.yo).to eql('busqué')
      expect(subject.tú).to eql('buscaste')
      expect(subject.él).to eql('buscó')
      expect(subject.usted).to eql('buscó')

      expect(subject.nosotros).to eql('buscamos')
      expect(subject.vosotros).to eql('buscasteis')
      expect(subject.ellos).to eql('buscaron')
      expect(subject.ustedes).to eql('buscaron')
    end
  end

  describe 'verbs ending with -gar' do
    subject { Verb.new('pagar').past }

    it 'changes c -> gu in the first person only' do
      expect(subject.exception?(:yo)).to be(true)

      expect(subject.yo).to eql('pagué')
      expect(subject.tú).to eql('pagaste')
      expect(subject.él).to eql('pagó')
      expect(subject.usted).to eql('pagó')

      expect(subject.nosotros).to eql('pagamos')
      expect(subject.vosotros).to eql('pagasteis')
      expect(subject.ellos).to eql('pagaron')
      expect(subject.ustedes).to eql('pagaron')
    end
  end

  describe 'verbs ending with -zar' do
    subject { Verb.new('realizar').past }

    it 'changes c -> c in the first person only' do
      expect(subject.exception?(:yo)).to be(true)

      expect(subject.yo).to eql('realicé')
      expect(subject.tú).to eql('realizaste')
      expect(subject.él).to eql('realizó')
      expect(subject.usted).to eql('realizó')

      expect(subject.nosotros).to eql('realizamos')
      expect(subject.vosotros).to eql('realizasteis')
      expect(subject.ellos).to eql('realizaron')
      expect(subject.ustedes).to eql('realizaron')
    end
  end

  describe 'ver' do
    subject { Verb.new('ver').past }

    it 'loses accent in the first and third person of singular' do
      expect(subject.exception?(:yo)).to be(true)
      expect(subject.exception?(:él)).to be(true)

      expect(subject.yo).to eql('vi')
      expect(subject.tú).to eql('viste')
      expect(subject.él).to eql('vio')
      expect(subject.usted).to eql('vio')

      expect(subject.nosotros).to eql('vimos')
      expect(subject.vosotros).to eql('visteis')
      expect(subject.ellos).to eql('vieron')
      expect(subject.ustedes).to eql('vieron')
    end
  end

  describe 'verbs ending with -er' do
    subject { Verb.new('comer').past }

    it 'is regular' do
      expect(subject.yo).to eql('comí')
      expect(subject.tú).to eql('comiste')
      expect(subject.él).to eql('comió')
      expect(subject.usted).to eql('comió')

      expect(subject.nosotros).to eql('comimos')
      expect(subject.vosotros).to eql('comisteis')
      expect(subject.ellos).to eql('comieron')
      expect(subject.ustedes).to eql('comieron')
    end
  end

  describe 'verbs ending with -ir' do
    subject { Verb.new('vivir').past }

    it 'is regular' do
      expect(subject.yo).to eql('viví')
      expect(subject.tú).to eql('viviste')
      expect(subject.él).to eql('vivió')
      expect(subject.usted).to eql('vivió')

      expect(subject.nosotros).to eql('vivimos')
      expect(subject.vosotros).to eql('vivisteis')
      expect(subject.ellos).to eql('vivieron')
      expect(subject.ustedes).to eql('vivieron')
    end
  end
end
