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

      # Google this.
      def syllables
        self.scan(//)
      end
    end
  end
end

require 'refined-refinements/string'
require 'refined-refinements/colours'
