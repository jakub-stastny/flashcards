# At the moment this is Spanish-only.
# It's easy to add different set of rules, but since we got rid off <lang>: flashcards,
# we don't really know which set of rules to apply.

# verb = Verb.new('hablar')
# puts verb.present.nosotros
class Verb
  def initialize(infinitive)
    @infinitive = infinitive
  end

  def tenses
    [self.present, self.past]
  end

  def present
    Tense.new(:present, @infinitive) do
      case @infinitive
      when /^(.+)ar$/
        [$1, {
          yo: 'o',   nosotros: 'amos',
          tú: 'as',  vosotros: 'áis',
          él: 'a',   ellos: 'an'
        }]
      when /^(.+)er$/
        [$1, {
          yo: 'o',   nosotros: 'emos',
          tú: 'es',  vosotros: 'éis',
          él: 'e',   ellos: 'en'
        }]
      when /^(.+)ir$/
        [$1, {
          yo: 'o',   nosotros: 'imos',
          tú: 'es',  vosotros: 'ís',
          él: 'e',   ellos: 'en'
        }]
      end
    end
  end

  def past
    Tense.new(:past, @infinitive) do
      case @infinitive
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
          él: 'ió',   ellos: 'ieron'
        }]
      end
    end
  end
end

class Tense
  attr_reader :tense, :forms
  def initialize(tense, infinitive, &block)
    @tense, @infinitive = tense, infinitive
    @root, @conjugations = self.instance_eval(&block)
    @conjugations[:usted] = @conjugations[:él]
    @conjugations[:ustedes] = @conjugations[:ellos]
    @forms = @conjugations.keys
  end

  [:yo, :tú, :él, :usted, :nosotros, :vosotros, :ellos, :ustedes].each do |method_name|
    define_method(method_name) { "#{@root}#{@conjugations[method_name]}" }
  end
end
