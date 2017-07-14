Flashcards.app.define_language(:es) do
  conjugation_group(:subjunctivo) do |infinitive|
    tense = Flashcards::Tense.new(:subjunctivo, infinitive) do
      case infinitive
      when /^(.+)ar(se)?$/
        [$1, {
           yo: 'e',   nosotros: 'emos',
vos: 'és', tú: 'es',  vosotros: 'éis',
           él: 'e',   ellos: 'en'
        }]
      when /^(.*)[ei]r(se)?$/ # ir, irse
        [$1, {
           yo: 'a',   nosotros: 'amos',
vos: 'ás', tú: 'as',  vosotros: 'áis',
           él: 'a',   ellos: 'an'
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
