require_relative '../indicativo/presente'
require_relative '../subjuntivo/presente'

Flashcards.app.define_language(:es) do
  conjugation_group(:imperativo_positivo) do |infinitive|
    tense = Flashcards::Tense.new(:imperativo_positivo, infinitive) do
      verb = Flashcards.app.language.load_verb(infinitive)

      [verb.subjuntivo.stem, {
        tú: delegate(:tú, verb.presente, :él),
        vos: infinitive.sub(/^.*(.)r(se)?$/) {
          Flashcards.app.language.syllabifier.accentuate($1, 0)
        },
        nosotros: delegate(:nosotros, verb.subjuntivo, :nosotros),
        vosotros: "#{infinitive[-2]}d"
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
