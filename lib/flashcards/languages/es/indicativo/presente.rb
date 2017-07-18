Flashcards.app.define_language(:es) do
  conjugation_group(:presente) do |verb, infinitive|
    tense = Flashcards::Tense.new(:presente, infinitive) do
      case self.infinitive
      when /^(.+)ar(se)?$/
        [$1, {
           yo: 'o',   nosotros: 'amos',
vos: 'ás', tú: 'as',  vosotros: 'áis',
           él: 'a',   ellos: 'an'
        }]
      when /^(.+)er(se)?$/
        [$1, {
           yo: 'o',   nosotros: 'emos',
vos: 'és', tú: 'es',  vosotros: 'éis',
           él: 'e',   ellos: 'en'
        }]
      when /^(.*)ir(se)?$/ # ir, irse
        [$1, {
           yo: 'o',   nosotros: 'imos',
vos: 'ís', tú: 'es',  vosotros: 'ís',
           él: 'e',   ellos: 'en'
        }]
      end
    end

    tense.irregular(/guir(se)?$/, yo: Proc.new { |stem| stem.sub(/u$/, 'o') })
    tense.irregular(/(gir|ger)(se)?$/, yo: Proc.new { |stem| stem.sub(/g$/, 'jo') })

    tense.alias_person(:ella, :él)
    tense.alias_person(:usted, :él)
    tense.alias_person(:nosotras, :nosotros)
    tense.alias_person(:vosotras, :vosotros)
    tense.alias_person(:ellas, :ellos)
    tense.alias_person(:ustedes, :ellos)

    tense.define_singleton_method(:pretty_inspect) do
      super(
        [nil, :vos, nil],
        [:yo, :tú, :él],
        [:nosotros, :vosotros, :ellos])
    end

    tense
  end
end
