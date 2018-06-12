# frozen_string_literal: true

require 'spec_helper'
require 'flashcards'
require 'flashcards/language'
require 'flashcards/languages/es/syllabifier'

describe Flashcards do
  let(:spanish) { Flashcards::App.new(:es).language }

  describe '#sounds' do
    it 'xxxxx' do
      expect(spanish.syllabifier.sounds('casa')).to eql(['c', 'a', 's', 'a'])
      expect(spanish.syllabifier.sounds('llamar')).to eql(['ll', 'a', 'm', 'a', 'r'])
      expect(spanish.syllabifier.sounds('chévere')).to eql(['ch', 'é', 'v', 'e', 'r', 'e'])
      expect(spanish.syllabifier.sounds('perro')).to eql(['p', 'e', 'rr', 'o'])
    end
  end

  describe '#syllables' do
    it 'xxxxx' do
      expect(spanish.syllabifier.syllables('sábana')).to eql(['sá', 'ba', 'na'])
      expect(spanish.syllabifier.syllables('oro')).to eql(['o', 'ro'])
    end

    it 'xxxxx' do
      expect(spanish.syllabifier.syllables('cuando')).to eql(['cuan', 'do'])
      expect(spanish.syllabifier.syllables('alcanzar')).to eql(['al', 'can', 'zar'])
      expect(spanish.syllabifier.syllables('costa')).to eql(['cos', 'ta'])
      # expect(spanish.syllabifier.syllables('sombrilla')).to eql(['som', 'bri', 'lla'])
      expect(spanish.syllabifier.syllables('clave')).to eql(['cla', 've'])
      expect(spanish.syllabifier.syllables('trabajo')).to eql(['tra', 'ba', 'jo'])
      # expect(spanish.syllabifier.syllables('aplicar')).to eql(['a', 'pli', 'car'])
      expect(spanish.syllabifier.syllables('frecuente')).to eql(['fre', 'cuen', 'te'])
      expect(spanish.syllabifier.syllables('hecho')).to eql(['he', 'cho'])
      # expect(spanish.syllabifier.syllables('amarillo')).to eql(['a', 'ma', 'ri', 'llo'])
      expect(spanish.syllabifier.syllables('carro')).to eql(['ca', 'rro'])
      # expect(spanish.syllabifier.syllables('merengue')).to eql(['me', 'ren', 'gue'])
      expect(spanish.syllabifier.syllables('extinguir')).to eql(['ex', 'tin', 'guir'])
    end

    # Words that begin with prefixes often violate the above rules.
    it 'xxxxx' do
      pending 'broken'
      expect(spanish.syllabifier.syllables('enloquecer')).to eql(['en', 'lo', 'que', 'cer'])
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
      pending 'broken'
      expect(spanish.syllabifier.syllables('atlántico')).to eql(['at', 'lán', 'ti', 'co'])
      expect(spanish.syllabifier.syllables('tlacuache')).to eql(['tla', 'cua', 'che'])
    end

    it 'xxxxx' do
      pending 'broken'
      expect(spanish.syllabifier.syllables('inglés')).to eql(['in', 'glés'])
      expect(spanish.syllabifier.syllables('compresar')).to eql(['com', 'pre', 'sar'])
      expect(spanish.syllabifier.syllables('panfleto')).to eql(['pan', 'fle', 'to'])
      expect(spanish.syllabifier.syllables('ombligo')).to eql(['om', 'bli', 'go'])
      expect(spanish.syllabifier.syllables('constante')).to eql(['con', 'stan', 'te'])
    end

    it 'xxxxx' do
      expect(spanish.syllabifier.syllables('toalla')).to eql(['to', 'a', 'lla'])
      expect(spanish.syllabifier.syllables('feo')).to eql(['fe', 'o'])
      expect(spanish.syllabifier.syllables('fui')).to eql(['fui'])
      expect(spanish.syllabifier.syllables('Juan')).to eql(['Juan'])
      expect(spanish.syllabifier.syllables('iguana')).to eql(['i', 'gua', 'na'])
      expect(spanish.syllabifier.syllables('reina')).to eql(['rei', 'na'])
      expect(spanish.syllabifier.syllables('tío')).to eql(['tí', 'o'])
      expect(spanish.syllabifier.syllables('ciudad')).to eql(['ciu', 'dad'])
      expect(spanish.syllabifier.syllables('creer')).to eql(['cre', 'er'])
    end
  end

  describe '#deaccentuate' do
    it 'xxxxx' do
      expect(spanish.syllabifier.deaccentuate('sábana')).to eql('sabana')
    end
  end

  describe '#accentuate' do
    it 'xxxxx' do
      expect(spanish.syllabifier.accentuate('sábana', 0)).to eql('sábana')
      expect(spanish.syllabifier.accentuate('sábana', 1)).to eql('sabána')
      expect(spanish.syllabifier.accentuate('sábana', 2)).to eql('sabaná')
      # expect { spanish.syllabifier.accentuate('sábana', 3) }.to raise_error(IndexError)
    end

    it 'xxxxx' do
      expect(spanish.syllabifier.accentuate('sábana', -1)).to eql('sabaná')
      expect(spanish.syllabifier.accentuate('sábana', -2)).to eql('sabána')
      expect(spanish.syllabifier.accentuate('sábana', -3)).to eql('sábana')
      # expect { spanish.syllabifier.accentuate('sábana', -4) }.to raise_error(IndexError)
    end
  end
end
