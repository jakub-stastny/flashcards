Flashcards.app.define_language(:es) do
  conjugation_group(:condicional) do |infinitive|
    tense = Flashcards::Tense.new(:condicional, infinitive) do
      # The endings for the conditional tense are the same as those for the -er
      # and -ir forms of the imperfect tense. However, conditional endings are
      # attached to the infinitive, while imperfect endings are attached to the stem.
      infinitive = infinitive.sub(/se$/, '')

      [infinitive, {
         yo: 'ía',   nosotros: 'íamos',
         tú: 'ías',  vosotros: 'íais',
         él: 'ía',   ellos: 'ían'
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
