Flashcards.app.define_language(:es) do
  conjugation_group(:pretérito) do |infinitive|
    tense = Flashcards::Tense.new(:pretérito, infinitive) do
      case infinitive
      when /^(.+)ar$/
        [$1, {
          yo: 'é',    nosotros: 'amos',
          tú: 'aste', vosotros: 'asteis',
          él: 'ó',    ellos: 'aron'
        }]
      when /^(.+)[ei]r$/
        [$1, {
          yo: 'í',    nosotros: 'imos',
          tú: 'iste', vosotros: 'isteis',
          él: 'ió',   ellos:    'ieron'
        }]
      end
    end

    tense.exception(/car$/, yo: Proc.new { |root| "#{root[0..-2]}qué" })
    tense.exception(/gar$/, yo: Proc.new { |root| "#{root[0..-2]}gué" })
    tense.exception(/zar$/, yo: Proc.new { |root| "#{root[0..-2]}cé"  })

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
