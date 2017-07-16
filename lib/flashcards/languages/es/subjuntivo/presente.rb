require_relative '../indicativo/presente'

Flashcards.app.define_language(:es) do
  conjugation_group(:subjunctivo) do |infinitive|
    tense = Flashcards::Tense.new(:subjunctivo, infinitive) do
      verb = Flashcards.app.language.load_verb(infinitive)
      root = verb.presente.yo[0..-2]

      case infinitive
      when /^(.+)ar(se)?$/
        [root, { # Using root here produces do- instead of d- for dar.
           yo: 'e',   nosotros: 'emos',
vos: 'és', tú: 'es',  vosotros: 'éis',
           él: 'e',   ellos: 'en'
        }]
      when /^(.*)[ei]r(se)?$/ # ir, irse
        [root, {
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
