Flashcards.app.define_language(:es) do
  conjugation_group(:imperfecto) do |infinitive|
    tense = Flashcards::Tense.new(:imperfecto, infinitive) do
      case infinitive
      when /^(.+)ar$/
        [$1, {
           yo: 'aba',   nosotros: 'ábamos',
           tú: 'abas',  vosotros: 'abais',
           él: 'aba',   ellos: 'aban'
        }]
      when /^(.+)[ei]r$/
        [$1, {
           yo: 'ía',   nosotros: 'íamos',
           tú: 'ías',  vosotros: 'íais',
           él: 'ía',   ellos: 'ían'
        }]
    end

    tense.alias_person(:vos, :tú)
    tense.alias_person(:usted, :él)
    tense.alias_person(:ustedes, :ellos)
    tense.alias_person(:nosotras, :nosotros)
    tense.alias_person(:vosotras, :vosotros)
  end
end

# There are only three verbs with irregular conjugations in the imperfect: ir, ser, and ver.
# iba, ibas, iba    | íbamos, ibais, iban
# era, eras, era    | éramos, erais, eran
# veía, veías, veía | veíamos, veíais, veían