# frozen_string_literal: true

module Flashcards
  module ES
    module Syllabifier
      VOWELS = ['a', 'e', 'i', 'o', 'u', 'á', 'é', 'í', 'ó', 'ú', 'ü'] +
               ['a', 'e', 'i', 'o', 'u', 'á', 'é', 'í', 'ó', 'ú', 'ü'].map(&:upcase)

      CONSONANTS = ('a'..'z').to_a + ['ñ', 'll', 'rr', 'ch'] - VOWELS +
                   ['Ll', 'Rr', 'Ch'] +
                   (('a'..'z').to_a + ['ñ', 'll', 'rr', 'ch'] - VOWELS).map(&:upcase)

      def self.vowels
        VOWELS
      end

      def self.consonants
        CONSONANTS
      end

      def self.sounds(word)
        word.each_char.each_with_object(Array.new) do |character, sounds|
          if /(ll|rr|ch)$/i.match?("#{sounds.last}#{character}")
            sounds[-1] += character
          else
            sounds << character
          end
        end
      end

      def self.syllables(word)
        sounds = self.sounds(word)
        syllables = sounds[1..-1].map.with_index.each_with_object([sounds[0]]) do |(sound, index), syllables|
          if self._should_append?(syllables.last, sound, sounds[index + 2])
            syllables[-1] += sound
          else
            syllables << sound
          end
        end

        # syllables.reduce(Array.new) do |syllables, syllable|
        #   if CONSONANTS.include?(syllable)
        #     syllables[-1] += syllable
        #   else
        #     syllables << syllable
        #   end
        #
        #   syllables
        # end
      end

      def self._should_append?(syllable, sound, next_sound)
        # is_final_r_l || is_second_strong_vowel
        # # if "#{syllables[-1]}#{sound}".match(/[#{VOWELS.join('')}] [#{CONSONANTS.join}] [#{VOWELS.join}]/)
        # is_second_strong_vowel = (VOWELS.include?(sound) && VOWELS.include?(syllables[-1]) && ['a', 'e', 'o'])
        # is_final_r_l = (CONSONANTS.include?(sound) && ! (CONSONANTS.include?(syllables[-1]) && ['r', 'l'].include?(sound)))

        accented_vowels = ['á', 'é', 'í', 'ó', 'ú', 'Á', 'É', 'Í', 'Ó', 'Ú']
        strong_vowels = ['a', 'e', 'o', 'A', 'E', 'O']
        r_l = ['r', 'l', 'R', 'L']

        two_consecutive_vowels = VOWELS.include?(syllable[-1]) && VOWELS.include?(sound)

        if two_consecutive_vowels && accented_vowels.include?(syllable[-1])
          return false # tí-o
        elsif two_consecutive_vowels && strong_vowels.include?(sound) && strong_vowels.include?(syllable[-1])
          return false # le-o
        elsif two_consecutive_vowels
          return true # fui
        elsif (CONSONANTS.include?(sound) && VOWELS.include?(next_sound)) && !(CONSONANTS.include?(syllable[-1]) && r_l.include?(sound))
          # oro, but not trabajo or clave.
          # oro: syllable: 'o', sound: 'r', next_sound: 'o' => false, do not append 'ro' to 'o'
          return false # o-ro
        elsif CONSONANTS.include?(sound) && next_sound.nil?
          return true # Juan
        elsif CONSONANTS.include?(sound) && CONSONANTS.include?(next_sound) && !r_l.include?(next_sound)
          return true # cuan-do
        elsif CONSONANTS.include?(sound) && r_l.include?(sound) && CONSONANTS.include?(syllable[-1])
          return true  # tra-ba-jo, cla-ve.
        elsif CONSONANTS.include?(sound) && CONSONANTS.include?(next_sound) && CONSONANTS.include?(syllable[-1])
          return false # in-[g]lés
        elsif VOWELS.include?(sound)
          return true
        else
          return false
          require 'pry'; binding.pry ###
          raise [:else, syllable, sound].inspect
        end
      end

      # word = 'dás'
      #
      # if word.sylables.length == 1 # ... and if it is not an exception.
      #   word.deaccentuate(/(.)s$/)
      #   # => 'das'
      # end
      def self.deaccentuate(word)
        word.tr('áéíóú', 'aeiou')
        # if syllable_index.nil?
        # else
        #   self.syllables.map.with_index do |syllable, index|
        #     if index == syllable_index
        #       syllable.sub(/[:vowel:]/) do |match|
        #         {'á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u'}
        #       end
        #     else
        #       syllable
        #     end
        #   end.join('')
        # end
      end

      def self.accentuate(word, syllable_index)
        s1 = syllable_index
        syllables = self.syllables(word)
        syllable_index = syllables.length + syllable_index if syllable_index < 0

        # if (0..(syllables.length)).include?(syllable_index)
        #   raise IndexError.new("#{syllable_index} is out of #{(0..(syllables.length))}.")
        # end

        self.syllables(self.deaccentuate(word)).map.with_index { |syllable, index|
          if index == syllable_index
            syllable.sub(/[aeiou]/) do
              {'a' => 'á', 'e' => 'é', 'i' => 'í', 'o' => 'ó', 'u' => 'ú'}[$&]
            end
          else
            syllable
          end
        }.join('')
      end
    end
  end
end
