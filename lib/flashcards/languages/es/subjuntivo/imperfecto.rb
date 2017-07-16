require_relative '../indicativo/preterito'

Flashcards.app.define_language(:es) do
  conjugation_group(:subjunctivo_imperfecto) do |infinitive|
    tense = Flashcards::Tense.new(:subjunctivo_imperfecto, infinitive) do
      verb = Flashcards.app.language.load_verb(infinitive)
      root = verb.pretérito.ellos[0..-4]

      [root, {
         yo: ['ra', 'se'],   nosotros: ['ramos', 'semos'], # TODO: There is an accent on the previous vowel (extrañásemos).
         tú: ['ras', 'ses'], vosotros: ['rais', 'seis'],
         él: ['ra', 'se'],   ellos: ['ran', 'sen']
      }]
    end

    tense.alias_person(:vos, :tú)
    tense.alias_person(:ella, :él)
    tense.alias_person(:usted, :él)
    tense.alias_person(:nosotras, :nosotros)
    tense.alias_person(:vosotras, :vosotros)
    tense.alias_person(:ellas, :ellos)
    tense.alias_person(:ustedes, :ellos)

    tense.define_singleton_method(:pretty_inspect) do
      super(
        [:yo, :tú, :él],
        [:nosotros, :vosotros, :ellos])
    end

    tense
  end
end
