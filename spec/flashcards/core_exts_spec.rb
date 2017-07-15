require 'flashcards/core_exts'

describe Array do
  using Flashcards::CoreExts

  subject do
    ['one', 'two', 'three']
  end

  describe '#join_with_and' do
    it 'xxxx' do
      expect(subject.join_with_and).to eql('one, two and three')
    end

    # TODO: args
  end
end

describe String do
  using Flashcards::CoreExts

  describe '#sounds' do
    it 'xxxxx' do
      expect('llamar'.sounds).to eql(['ll', 'a', 'm', 'a', 'r'])
      expect('chévere'.sounds).to eql(['ch', 'é', 'v', 'e', 'r', 'e'])
    end
  end

  describe '#syllables' do
    it 'xxxxx' do
      expect('sábana'.syllables).to eql(['sá', 'ba', 'na'])
      expect('oro'.syllables).to eql(['o', 'ro'])
      expect('cuando'.syllables).to eql(['cuan', 'do'])
      expect('alcanzar'.syllables).to eql(['al', 'can', 'zar'])
      expect('costa'.syllables).to eql(['cos', 'ta'])
      expect('sombrilla'.syllables).to eql(['som', 'bri', 'lla'])
      expect('clave'.syllables).to eql(['cla', 've'])
      expect('trabajo'.syllables).to eql(['tra', 'ba', 'jo'])
      expect('aplicar'.syllables).to eql(['a', 'pli', 'car'])
      expect('frecuente'.syllables).to eql(['fre', 'cuen', 'te'])
      expect('hecho'.syllables).to eql(['he', 'cho'])
      expect('amarillo'.syllables).to eql(['a', 'ma', 'ri', 'llo'])
      expect('carro'.syllables).to eql(['ca', 'rro'])
      expect('merengue'.syllables).to eql(['me', 'ren', 'gue'])

      # Words that begin with prefixes often violate the above rules.
      # expect('enloquecer'.syllables).to eql(['en', 'lo', 'que', 'cer'])

      # In Puerto Rico and most of Spain, the consonant cluster tl is divided into
      # separate syllables. For example, the syllabification of atlántico is at-lán-ti-co.
      # In other regions, such as Mexico and the Canary Islands of Spain,
      # the consonant cluster tl is not divided into separate syllables.
      # For example, the syllabification of atlántico is a-tlán-ti-co and
      # the syllabification of tlacuache (possum) is tla-cua-che.
      # expect('atlántico'.syllables).to eql(['at', 'lán', 'ti', 'co']) # At least out of Canary Islands and México.

      expect('inglés'.syllables).to eql(['in', 'glés'])
      expect('compresar'.syllables).to eql(['com', 'pre', 'sar'])
      expect('panfleto'.syllables).to eql(['pan', 'fle', 'to'])
      expect('ombligo'.syllables).to eql(['om', 'bli', 'go'])
      # expect('constante'.syllables).to eql(['con', 'stan', 'te'])

      # expect('toalla'.syllables).to eql(['to', 'a', 'lla'])
      # expect('feo'.syllables).to eql(['fe', 'o'])
      expect('iguana'.syllables).to eql(['i', 'gua', 'na'])
      expect('reina'.syllables).to eql(['rei', 'na'])
      # expect('tío'.syllables).to eql(['tí', 'o'])
      expect('ciudad'.syllables).to eql(['ciu', 'dad'])
      # expect('creer'.syllables).to eql(['cre', 'er'])
    end
  end
end
