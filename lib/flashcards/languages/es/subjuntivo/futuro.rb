require_relative '../indicativo/preterito'

Flashcards.app.define_language(:es) do
  conjugation_group(:subjunctivo_futuro) do |infinitive|
    tense = Flashcards::Tense.new(:subjunctivo_futuro, infinitive) do
      verb = Flashcards.app.language.verb(infinitive) # This way no exceptions. We have to access the flashcards data.
      root = verb.pretérito.ellos[0..-4]

      [root, {
         yo: 're',   nosotros: 'remos', # TODO: accent is common: hubiéremos, supiéremos
         tú: 'res',  vosotros: 'reis',
         él: 're',   ellos: 'ren'
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
