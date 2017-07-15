module Flashcards
  module CoreExts
    refine Array do
      def join_with_and(xxx = 'and', delimiter = ', ')
        return self[0] if self.length == 1
        "#{self[0..-2].join(delimiter)} #{xxx} #{self[-1]}"
      end
    end

    refine String do
      # word = 'dás'
      #
      # if word.sylables.length == 1 # ... and if it is not an exception.
      #   word.deaccentuate(/(.)s$/)
      #   # => 'das'
      # end
      def deaccentuate(syllable_index = nil)
        if syllable_index.nil?
          self.tr('áéíóú', 'aeiou')
        else
          self.syllables.map.with_index do |syllable, index|
            if index == syllable_index
              syllable.sub(/[:vowel:]/) do |match|
                {'á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u'}
              end
            else
              syllable
            end
          end.join('')
        end
      end

      def accentuate(syllable_index)
        self.sub(regexp) do
          $1.tr('aeiou', 'áéíóú')
        end
      end

      # class Sound
      #   attr_reader :sound
      #   def initialize(sound)
      #     @sound = sound
      #   end
      # end

      def sounds
        self.each_char.reduce(Array.new) do |syllables, character|
          if (character == 'l' && syllables.last == 'l') || (character == 'h' && syllables.last == 'c')
            syllables[-1] += character
          else
            syllables << character
          end

          syllables
        end
      end

      VOWELS = ['a', 'e', 'i', 'o', 'u', 'á', 'é', 'í', 'ó', 'ú', 'ü']
      CONSONANTS = ('a'..'z').to_a + ['ñ', 'll', 'ch'] - VOWELS
      def syllables
        syllables = self.sounds.reduce(Array.new) do |syllables, sound|
          if (CONSONANTS.include?(sound) && ! (CONSONANTS.include?(syllables[-1]) && ['r', 'l'].include?(sound))) || syllables.empty?
            syllables << sound
          else
            syllables[-1] += sound
          end

          syllables
        end

        syllables.reduce(Array.new) do |syllables, syllable|
          if CONSONANTS.include?(syllable)
            syllables[-1] += syllable
          else
            syllables << syllable
          end

          syllables
        end
      end
    end
  end
end

require 'refined-refinements/string'
require 'refined-refinements/colours'
