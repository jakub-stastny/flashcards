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
    @past ||= begin
      tense = Tense.new(:past, @infinitive) do
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

      tense.exception(/car$/, yo: Proc.new { |root| "#{root[0..-2]}qué" })
      tense.exception(/gar$/, yo: Proc.new { |root| "#{root[0..-2]}gué" })
      tense.exception(/zar$/, yo: Proc.new { |root| "#{root[0..-2]}cé"  })

      tense
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
    @exceptions = Hash.new
  end

  [:yo, :tú, :él, :usted, :nosotros, :vosotros, :ellos, :ustedes].each do |method_name|
    define_method(method_name) do
      exceptions = @exceptions.select { |match, _| @infinitive.match(match) }.values
      case exceptions.length
      when 0
        "#{@root}#{@conjugations[method_name]}"
      when 1
        conjugations = @conjugations.merge(exceptions[0]).reduce(Hash.new) do |conjugations, (conjugation, value)|
          value = value.is_a?(Proc) ? value.call(@root) : "#{@root}#{value}"
          conjugations.merge(conjugation => value)
        end
        conjugations[method_name]
      else
        raise "There can't be more than 1 exception! #{exceptions.inspect}"
      end
    end
  end

  def exception(match, forms)
    @exceptions[match] = forms
  end
end
