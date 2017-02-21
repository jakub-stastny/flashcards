# At the moment this is Spanish-only.
# It's easy to add different set of rules, but since we got rid off <lang>: flashcards,
# we don't really know which set of rules to apply.

# verb = Verb.new('hablar')
# puts verb.present.nosotros
class Verb
  def initialize(infinitive)
    @infinitive = infinitive
  end

  def present
    Tense.new(:present, @infinitive) do
      case @infinitive
      when /^(.+)ar$/
        [$1, {
          yo: 'o',   nosotros: 'amos',
          tu: 'as',  vosotros: 'ais',
          el: 'a',   ellos: 'an'
        }]
      when /^(.+)er$/
        [$1, {
          yo: 'o',   nosotros: 'emos',
          tu: 'es',  vosotros: 'eis',
          el: 'e',   ellos: 'en'
        }]
      when /^(.+)ir$/
        [$1, {
          yo: 'o',   nosotros: 'imos',
          tu: 'es',  vosotros: 'is',
          el: 'e',   ellos: 'en'
        }]
      end
    end
  end

  def past
    Tense.new(:present, @infinitive) do
      case @infinitive
      when /^(.+)ar$/
        [$1, {
          yo: 'é',    nosotros: 'amos',
          tu: 'aste', vosotros: 'asteis',
          el: 'ó',    ellos: 'aron'
        }]
      when /^(.+)[ei]r$/
        [$1, {
          yo: 'í',    nosotros: 'imos',
          tu: 'iste', vosotros: 'isteis',
          el: 'ió',   ellos: 'ieron'
        }]
      end
    end
  end
end

class Tense
  def initialize(tense, infinitive, &block)
    @tense, @infinitive = tense, infinitive
    @root, @conjugations = self.instance_eval(&block)
  end

  [:yo, :tu, :el, :nosotros, :vosotros, :ellos].each do |method_name|
    define_method(method_name) { "#{@root}#{@conjugations[method_name]}" }
  end

  alias_method :usted, :el
  alias_method :ustedes, :ellos
end
