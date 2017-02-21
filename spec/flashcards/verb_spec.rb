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
