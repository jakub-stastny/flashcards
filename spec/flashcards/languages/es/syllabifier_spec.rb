require 'flashcards/languages/es/syllabifier'

describe Flashcards do
  describe '#sounds' do
    it 'xxxxx' do
      expect(Flashcards.sounds('casa')).to eql(['c', 'a', 's', 'a'])
      expect(Flashcards.sounds('llamar')).to eql(['ll', 'a', 'm', 'a', 'r'])
      expect(Flashcards.sounds('chévere')).to eql(['ch', 'é', 'v', 'e', 'r', 'e'])
      expect(Flashcards.sounds('perro')).to eql(['p', 'e', 'rr', 'o'])
    end
  end

  describe '#syllables' do
    it 'xxxxx' do
      expect(Flashcards.syllables('sábana')).to eql(['sá', 'ba', 'na'])
      expect(Flashcards.syllables('oro')).to eql(['o', 'ro'])
    end

    it 'xxxxx' do
      expect(Flashcards.syllables('cuando')).to eql(['cuan', 'do'])
      expect(Flashcards.syllables('alcanzar')).to eql(['al', 'can', 'zar'])
      expect(Flashcards.syllables('costa')).to eql(['cos', 'ta'])
      # expect(Flashcards.syllables('sombrilla')).to eql(['som', 'bri', 'lla'])
      expect(Flashcards.syllables('clave')).to eql(['cla', 've'])
      expect(Flashcards.syllables('trabajo')).to eql(['tra', 'ba', 'jo'])
      # expect(Flashcards.syllables('aplicar')).to eql(['a', 'pli', 'car'])
      expect(Flashcards.syllables('frecuente')).to eql(['fre', 'cuen', 'te'])
      expect(Flashcards.syllables('hecho')).to eql(['he', 'cho'])
      # expect(Flashcards.syllables('amarillo')).to eql(['a', 'ma', 'ri', 'llo'])
      expect(Flashcards.syllables('carro')).to eql(['ca', 'rro'])
      # expect(Flashcards.syllables('merengue')).to eql(['me', 'ren', 'gue'])
      expect(Flashcards.syllables('extinguir')).to eql(['ex', 'tin', 'guir'])
    end

    # Words that begin with prefixes often violate the above rules.
    it 'xxxxx' do
      expect(Flashcards.syllables('enloquecer')).to eql(['en', 'lo', 'que', 'cer'])
    end

    # In Puerto Rico and most of Spain, the consonant cluster tl is divided into
    # separate syllables. For example, the syllabification of atlántico is at-lán-ti-co.
    #
    # In other regions, such as Mexico and the Canary Islands of Spain,
    # the consonant cluster tl is not divided into separate syllables.
    #
    # For example, the syllabification of atlántico is a-tlán-ti-co and
    # the syllabification of tlacuache (possum) is tla-cua-che.
    it 'xxxxx' do
      expect(Flashcards.syllables('atlántico')).to eql(['at', 'lán', 'ti', 'co'])
      expect(Flashcards.syllables('tlacuache')).to eql(['tla', 'cua', 'che'])
    end

    it 'xxxxx' do
      expect(Flashcards.syllables('inglés')).to eql(['in', 'glés'])
      expect(Flashcards.syllables('compresar')).to eql(['com', 'pre', 'sar'])
      expect(Flashcards.syllables('panfleto')).to eql(['pan', 'fle', 'to'])
      expect(Flashcards.syllables('ombligo')).to eql(['om', 'bli', 'go'])
      expect(Flashcards.syllables('constante')).to eql(['con', 'stan', 'te'])
    end

    it 'xxxxx' do
      expect(Flashcards.syllables('toalla')).to eql(['to', 'a', 'lla'])
      expect(Flashcards.syllables('feo')).to eql(['fe', 'o'])
      expect(Flashcards.syllables('fui')).to eql(['fui'])
      expect(Flashcards.syllables('Juan')).to eql(['Juan'])
      expect(Flashcards.syllables('iguana')).to eql(['i', 'gua', 'na'])
      expect(Flashcards.syllables('reina')).to eql(['rei', 'na'])
      expect(Flashcards.syllables('tío')).to eql(['tí', 'o'])
      expect(Flashcards.syllables('ciudad')).to eql(['ciu', 'dad'])
      expect(Flashcards.syllables('creer')).to eql(['cre', 'er'])
    end
  end

  describe '#deaccentuate' do
    it 'xxxxx' do
      expect(Flashcards.deaccentuate('sábana')).to eql('sabana')
    end
  end

  describe '#accentuate' do
    it 'xxxxx' do
      expect(Flashcards.accentuate('sábana', 0)).to eql('sábana')
      expect(Flashcards.accentuate('sábana', 1)).to eql('sabána')
      expect(Flashcards.accentuate('sábana', 2)).to eql('sabaná')
      # expect { Flashcards.accentuate('sábana', 3) }.to raise_error(IndexError)
    end

    it 'xxxxx' do
      expect(Flashcards.accentuate('sábana', -1)).to eql('sabaná')
      expect(Flashcards.accentuate('sábana', -2)).to eql('sabána')
      expect(Flashcards.accentuate('sábana', -3)).to eql('sábana')
      # expect { Flashcards.accentuate('sábana', -4) }.to raise_error(IndexError)
    end
  end
end
