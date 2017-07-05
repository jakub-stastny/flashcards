Flashcards.app.define_language(:es) do
  conjugation_group(:futuro) do |infinitive|
    tense = Flashcards::Tense.new(:futuro, infinitive) do
      [infinitive, {
         yo: 'é',   nosotros: 'emos',
         tú: 'ás',  vosotros: 'éis',
         él: 'á',   ellos: 'án'
      }]
    end

    tense.alias_person(:vos, :tú)
    tense.alias_person(:usted, :él)
    tense.alias_person(:ustedes, :ellos)

    tense.define_singleton_method(:pretty_inspect) do
      super(
        [:yo, :tú, :él],
        [:nosotros, :vosotros, :ellos])
    end

    tense
  end
end
