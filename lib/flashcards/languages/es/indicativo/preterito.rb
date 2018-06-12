# frozen_string_literal: true

Flashcards::Language.define(:es) do
  conjugation_group(:pretérito) do |verb, infinitive|
    tense = Flashcards::Tense.new(self, :pretérito, infinitive) do
      case self.infinitive
      when /^(.+)ar(se)?$/
        [Regexp.last_match(1), {
          yo: 'é',    nosotros: 'amos',
          tú: 'aste', vosotros: 'asteis',
          él: 'ó',    ellos: 'aron'
        }]
      when /^(.*)[ei]r(se)?$/ # ir, irse
        [Regexp.last_match(1), {
          yo: 'í',    nosotros: 'imos',
          tú: 'iste', vosotros: 'isteis',
          él: 'ió',   ellos:    'ieron'
        }]
      end
    end

    tense.irregular(/car(se)?$/, yo: Proc.new { |stem| "#{stem[0..-2]}qué" })
    tense.irregular(/gar(se)?$/, yo: Proc.new { |stem| "#{stem[0..-2]}gué" })
    tense.irregular(/zar(se)?$/, yo: Proc.new { |stem| "#{stem[0..-2]}cé"  })

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
