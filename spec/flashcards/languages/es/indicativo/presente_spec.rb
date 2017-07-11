require 'flashcards'
require 'flashcards/language'

describe 'Present tense' do
  let(:spanish) { Flashcards.app.language }

  describe 'verbs ending with -ar' do
    let(:hablar) { spanish.verb('hablar') }

    it 'is regular' do
      [:yo, :tú, :vos, :él, :usted, :nosotros, :vosotros, :ellos, :ustedes].each do |person|
        expect(hablar.presente.irregular?(person)).to be(false)
      end

      expect(hablar.presente.yo).to eql('hablo')
      expect(hablar.presente.tú).to eql('hablas')
      expect(hablar.presente.vos).to eql('hablás')
      expect(hablar.presente.él).to eql('habla')
      expect(hablar.presente.usted).to eql('habla')

      expect(hablar.presente.nosotros).to eql('hablamos')
      expect(hablar.presente.vosotros).to eql('habláis')
      expect(hablar.presente.ellos).to eql('hablan')
      expect(hablar.presente.ustedes).to eql('hablan')
    end
  end

  describe 'verbs ending with -er' do
    let(:comer) { spanish.verb('comer') }

    it 'is regular' do
      [:yo, :tú, :vos, :él, :usted, :nosotros, :vosotros, :ellos, :ustedes].each do |person|
        expect(comer.presente.irregular?(person)).to be(false)
      end

      expect(comer.presente.yo).to eql('como')
      expect(comer.presente.tú).to eql('comes')
      expect(comer.presente.vos).to eql('comés')
      expect(comer.presente.él).to eql('come')
      expect(comer.presente.usted).to eql('come')

      expect(comer.presente.nosotros).to eql('comemos')
      expect(comer.presente.vosotros).to eql('coméis')
      expect(comer.presente.ellos).to eql('comen')
      expect(comer.presente.ustedes).to eql('comen')
    end
  end

  describe 'verbs ending with -ir' do
    let(:vivir) { spanish.verb('vivir') }

    it 'is regular' do
      [:yo, :tú, :vos, :él, :usted, :nosotros, :vosotros, :ellos, :ustedes].each do |person|
        expect(vivir.presente.irregular?(person)).to be(false)
      end

      expect(vivir.presente.yo).to eql('vivo')
      expect(vivir.presente.tú).to eql('vives')
      expect(vivir.presente.vos).to eql('vivís')
      expect(vivir.presente.él).to eql('vive')
      expect(vivir.presente.usted).to eql('vive')

      expect(vivir.presente.nosotros).to eql('vivimos')
      expect(vivir.presente.vosotros).to eql('vivís')
      expect(vivir.presente.ellos).to eql('viven')
      expect(vivir.presente.ustedes).to eql('viven')
    end
  end

  describe 'extinguir' do
    let(:extinguir) { spanish.verb('extinguir') }

    it 'is irregular in the first form of singular' do
      expect(extinguir.presente.irregular?(:yo)).to be(true)
      [:tú, :vos, :él, :usted, :nosotros, :vosotros, :ellos, :ustedes].each do |person|
        expect(extinguir.presente.irregular?(person)).to be(false)
      end

      expect(extinguir.presente.yo).to eql('extingo')
      expect(extinguir.presente.tú).to eql('extingues')
      expect(extinguir.presente.vos).to eql('extinguís')
      expect(extinguir.presente.él).to eql('extingue')
      expect(extinguir.presente.usted).to eql('extingue')

      expect(extinguir.presente.nosotros).to eql('extinguimos')
      expect(extinguir.presente.vosotros).to eql('extinguís')
      expect(extinguir.presente.ellos).to eql('extinguen')
      expect(extinguir.presente.ustedes).to eql('extinguen')
    end
  end

  describe 'escoger' do
    let(:escoger) { spanish.verb('escoger') }

    it 'is irregular in the first form of singular' do
      expect(escoger.presente.irregular?(:yo)).to be(true)
      [:tú, :vos, :él, :usted, :nosotros, :vosotros, :ellos, :ustedes].each do |person|
        expect(escoger.presente.irregular?(person)).to be(false)
      end

      expect(escoger.presente.yo).to eql('escojo')
      expect(escoger.presente.tú).to eql('escoges')
      expect(escoger.presente.vos).to eql('escogés')
      expect(escoger.presente.él).to eql('escoge')
      expect(escoger.presente.usted).to eql('escoge')

      expect(escoger.presente.nosotros).to eql('escogemos')
      expect(escoger.presente.vosotros).to eql('escogéis')
      expect(escoger.presente.ellos).to eql('escogen')
      expect(escoger.presente.ustedes).to eql('escogen')
    end
  end

  describe 'dirigir' do
    let(:dirigir) { spanish.verb('dirigir') }

    it 'is irregular in the first form of singular' do
      expect(dirigir.presente.irregular?(:yo)).to be(true)
      [:tú, :vos, :él, :usted, :nosotros, :vosotros, :ellos, :ustedes].each do |person|
        expect(dirigir.presente.irregular?(person)).to be(false)
      end

      expect(dirigir.presente.yo).to eql('dirijo')
      expect(dirigir.presente.tú).to eql('diriges')
      expect(dirigir.presente.vos).to eql('dirigís')
      expect(dirigir.presente.él).to eql('dirige')
      expect(dirigir.presente.usted).to eql('dirige')

      expect(dirigir.presente.nosotros).to eql('dirigimos')
      expect(dirigir.presente.vosotros).to eql('dirigís')
      expect(dirigir.presente.ellos).to eql('dirigen')
      expect(dirigir.presente.ustedes).to eql('dirigen')
    end
  end

  # Single exceptions are now defined within flashcards.
  describe 'dar' do
    let(:dar) { spanish.verb('dar', presente: {yo: 'doy', vosotros: 'dais'}) }

    it 'is irregular in the first form of singular and second form of plural' do
      [:yo, :vosotros].each do |person|
        expect(dar.presente.irregular?(person)).to be(true)
      end

      [:tú, :vos, :él, :usted, :nosotros, :ellos, :ustedes].each do |person|
        expect(dar.presente.irregular?(person)).to be(false)
      end

      expect(dar.presente.yo).to eql('doy')
      expect(dar.presente.tú).to eql('das')
      expect(dar.presente.vos).to eql('dás')
      expect(dar.presente.él).to eql('da')
      expect(dar.presente.usted).to eql('da')

      expect(dar.presente.nosotros).to eql('damos')
      expect(dar.presente.vosotros).to eql('dais')
      expect(dar.presente.ellos).to eql('dan')
      expect(dar.presente.ustedes).to eql('dan')
    end
  end
end
