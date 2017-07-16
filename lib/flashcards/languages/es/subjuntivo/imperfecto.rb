require_relative '../indicativo/preterito'

Flashcards.app.define_language(:es) do
  conjugation_group(:subjunctivo_imperfecto) do |infinitive|
    tense = Flashcards::Tense.new(:subjunctivo_imperfecto, infinitive) do
      verb = Flashcards.app.language.load_verb(infinitive)
      root = verb.pretérito.ellos[0..-4]

      # NOTE: It might or might not be the right stem, but anyhow, I don't think it matters.
      [root[0..-2], {
         yo: ["#{root[-1]}ra", "#{root[-1]}se"],   nosotros: ["#{Flashcards.accentuate(root[-1], 0)}ramos", "#{Flashcards.accentuate(root[-1], 0)}semos"],
         tú: ["#{root[-1]}ras", "#{root[-1]}ses"], vosotros: ["#{root[-1]}rais", "#{root[-1]}seis"],
         él: ["#{root[-1]}ra", "#{root[-1]}se"],   ellos: ["#{root[-1]}ran", "#{root[-1]}sen"]
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
