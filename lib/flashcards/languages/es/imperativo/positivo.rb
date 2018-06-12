# frozen_string_literal: true

require_relative '../indicativo/presente'
require_relative '../subjuntivo/presente'

Flashcards::Language.define(:es) do
  conjugation_group(:imperativo_positivo) do |verb, infinitive|
    language = self
    tense = Flashcards::Tense.new(self, :imperativo_positivo, infinitive) do
      [verb.subjuntivo.stem, {
        tú: delegate(:tú, verb.presente, :él),
        vos: {
          stem: infinitive.sub(/(se)?$/, '')[0..-3],
          ending: infinitive.sub(/^.*(.)r(se)?$/) do
            if language.syllabifier.syllables(infinitive[0..-2]).length > 1
              language.syllabifier.accentuate(Regexp.last_match(1), 0)
            else
              Regexp.last_match(1)
            end
          end
        },
        nosotros: delegate(:nosotros, verb.subjuntivo, :nosotros),
        vosotros: {
          stem: infinitive.sub(/(se)?$/, '')[0..-3],
          ending: "#{infinitive.sub(/(se)?$/, '')[-2]}d"
        }
      }]
    end

    tense.alias_person :nosotras, :nosotros
    tense.alias_person :vosotras, :vosotros

    tense.define_singleton_method(:pretty_inspect) do
      super([nil, :vos], [nil, :tú], [:nosotros, :vosotros])
    end

    tense
  end
end
