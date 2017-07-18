Flashcards.app.define_language(:es) do
  conjugation_group(:futuro) do |verb, infinitive|
    tense = Flashcards::Tense.new(:futuro, infinitive) do
      [self.infinitive, {
         yo: 'é',   nosotros: 'emos',
         tú: 'ás',  vosotros: 'éis',
         él: 'á',   ellos: 'án'
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
