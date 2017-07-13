Flashcards.app.define_language(:es) do
  conjugation_group(:imperfecto) do |infinitive|
    tense = Flashcards::Tense.new(:imperfecto, infinitive) do
      case infinitive
      when /^(.+)ar(se)?$/
        [$1, {
           yo: 'aba',   nosotros: 'ábamos',
           tú: 'abas',  vosotros: 'abais',
           él: 'aba',   ellos: 'aban'
        }]
      when /^(.*)[ei]r(se)?$/
        [$1, {
           yo: 'ía',   nosotros: 'íamos',
           tú: 'ías',  vosotros: 'íais',
           él: 'ía',   ellos: 'ían'
        }]
      end
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

# There are only three verbs with irregular conjugations in the imperfect: ir, ser, and ver.
# iba, ibas, iba    | íbamos, ibais, iban
# era, eras, era    | éramos, erais, eran
# veía, veías, veía | veíamos, veíais, veían
