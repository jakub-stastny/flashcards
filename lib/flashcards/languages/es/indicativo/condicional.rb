Flashcards.app.define_language(:es) do
  conjugation_group(:condicional) do |infinitive|
    tense = Flashcards::Tense.new(:condicional, infinitive) do
      # The endings for the conditional tense are the same as those for the -er
      # and -ir forms of the imperfect tense. However, conditional endings are
      # attached to the infinitive, while imperfect endings are attached to the stem.
      infinitive = infinitive.match(/^(.*[aei]r)(se)?$/)[1]
      [infinitive, {
         yo: 'ía',   nosotros: 'íamos',
         tú: 'ías',  vosotros: 'íais',
         él: 'ía',   ellos: 'ían'
      }]
    end

    # tense.irregular(/guir(se)?$/, yo: Proc.new { |root| root.sub(/u$/, 'o') })
    # tense.irregular(/(gir|ger)(se)?$/, yo: Proc.new { |root| root.sub(/g$/, 'jo') })

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
