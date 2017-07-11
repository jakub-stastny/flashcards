require 'flashcards'
require 'flashcards/language'

describe 'Informal commands' do
  let(:spanish) { Flashcards.app.language }

  describe 'affirmative' do
    let(:hablar) { spanish.verb('hablar') }

    it do
      # require 'pry'; binding.pry ###
      expect(hablar.imperativo_positivo.tú).to eql('habla')
      expect(hablar.imperativo_positivo.vos).to eql('hablá')
      expect(hablar.imperativo_formal.usted).to eql('hable')
      expect(hablar.imperativo_negativo.tú).to eql('hables')
      expect(hablar.imperativo_negativo.vos).to eql('hables')
      # hablar.imperativo_formal.{usted,nosotros?,ustedes}
      # hablar.imperativo_positivo.{tú,vos,nosotros,vosotros}
      # hablar.imperativo_negativo.{tú,vos,nosotros,vosotros}
      # require 'pry'; binding.pry ###
    end

  #   it 'is regular' do
  #     expect(hablar.presente.irregular?(:tú)).to be(false)
  #     expect(hablar.presente.irregular?(:vos)).to be(false)
  #     expect(hablar.presente.irregular?(:nosotros)).to be(false)
  #
  #     expect(hablar.presente.tú).to eql('habla')
  #     expect(hablar.presente.vos).to eql('hablxxxx')
  #     expect(hablar.presente.nosotros).to eql('hablamonos')
  #   end
  #
  #   it 'is irregular' do
  #     expect(hablar.presente.irregular?(:tú)).to be(false) # this won't work, since we're not proxying exceptions.
  #     expect(hablar.presente.irregular?(:vos)).to be(false)
  #     expect(hablar.presente.irregular?(:nosotros)).to be(false)
  #
  #     expect(hablar.presente.tú).to eql('habla')
  #     expect(hablar.presente.vos).to eql('hablxxxx')
  #     expect(hablar.presente.nosotros).to eql('hablamonos')
  #   end
  # end
  #
  # describe 'negative' do
  #   #
  end
end
