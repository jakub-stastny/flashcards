require_relative '../indicativo/preterito'

Flashcards.app.define_language(:es) do
  conjugation_group(:subjuntivo_imperfecto) do |verb, infinitive|
    tense = Flashcards::Tense.new(:subjuntivo_imperfecto, infinitive) do
      if verb.infinitive != infinitive # Irregular infinitive.
        stem = self.infinitive[0..-4]
      else
        stem = verb.pretérito.ellos[0..-4]
      end

      # NOTE: It might or might not be the right stem, but anyhow, I don't think it matters.
      [stem[0..-2], {
         yo: ["#{stem[-1]}ra", "#{stem[-1]}se"],   nosotros: ["#{Flashcards.app.language.syllabifier.accentuate(stem[-1], 0)}ramos", "#{Flashcards.app.language.syllabifier.accentuate(stem[-1], 0)}semos"],
         tú: ["#{stem[-1]}ras", "#{stem[-1]}ses"], vosotros: ["#{stem[-1]}rais", "#{stem[-1]}seis"],
         él: ["#{stem[-1]}ra", "#{stem[-1]}se"],   ellos: ["#{stem[-1]}ran", "#{stem[-1]}sen"]
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
