require_relative '../indicativo/presente'
require_relative '../subjuntivo/presente'

Flashcards::Language.define(:es) do
  conjugation_group(:imperativo_positivo) do |verb, infinitive|
    language = self
    tense = Flashcards::Tense.new(self, :imperativo_positivo, infinitive) do
      [verb.subjuntivo.stem, {
        tú: delegate(:tú, verb.presente, :él),
        vos: infinitive.sub(/^.*(.)r(se)?$/) {
          language.syllabifier.accentuate($1, 0)
        },
        nosotros: delegate(:nosotros, verb.subjuntivo, :nosotros),
        vosotros: "#{infinitive[-2]}d" # This uses stem from the infinitive (tened).
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
