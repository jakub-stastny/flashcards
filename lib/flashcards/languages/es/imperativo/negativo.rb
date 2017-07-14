require_relative './formal'
require_relative '../subjuntivo/presente'

Flashcards.app.define_language(:es) do
  conjugation_group(:imperativo_negativo) do |infinitive|
    tense = Flashcards::Tense.new(:imperativo_negativo, infinitive) do
      verb = Flashcards.app.language.verb(infinitive)
      root = infinitive[0..-3]

      [root, {
        tú: delegate(:tú, verb.imperativo_formal, :usted) { |command| "#{command}s" },
        nosotros: delegate(:nosotros, verb.subjunctivo, :nosotros),
        vosotros: delegate(:vosotros, verb.subjunctivo, :vosotros)
      }]
    end

    tense.alias_person :vos, :tú
    tense.alias_person :nosotras, :nosotros
    tense.alias_person :vosotras, :vosotros

    tense.define_singleton_method(:pretty_inspect) do
      super([nil, :tú], [:nosotros, :vosotros])
    end

    tense
  end
end
