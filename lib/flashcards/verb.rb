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
    tense = Tense.new(:present, @infinitive) do
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

    # TODO: Rename to #exception to #irregular or somethin'.
    tense.exception('dar', yo: 'doy', vosotros: 'dais')

    tense
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
            él: 'ió',   ellos:    'ieron'
          }]
        end
      end

      tense.exception(/car$/, yo: Proc.new { |root| "#{root[0..-2]}qué" })
      tense.exception(/gar$/, yo: Proc.new { |root| "#{root[0..-2]}gué" })
      tense.exception(/zar$/, yo: Proc.new { |root| "#{root[0..-2]}cé"  })

      # Ver loses accent in the first and third person of singular .
      tense.exception('ver', yo: 'vi', él: 'vio')

      # Dar loses accent in the first and third person of singular and is conjugated such as -er/-ir verbs.
      tense.exception('dar', {
        yo: 'di',    nosotros: 'dimos',
        tú: 'diste', vosotros: 'disteis',
        él: 'dio',   ellos:    'dieron'
      })

      tense
    end
  end
end

class Tense
  attr_reader :tense, :forms
  def initialize(tense, infinitive, &block)
    @tense, @infinitive = tense, infinitive
    @root, @conjugations = self.instance_eval(&block)
    @forms = @conjugations.keys
    @exceptions = Hash.new
  end

  PERSONS = [:yo, :tú, :él, :nosotros, :vosotros, :ellos, :ustedes]

  PERSONS.each do |method_name|
    define_method(method_name) { self.forms[method_name] }
  end
  alias_method :usted, :él
  alias_method :ustedes, :ellos

  def regular_forms
    PERSONS.reduce(Hash.new) do |buffer, person|
      unless self.irregular_forms.include?(person)
        buffer.merge(person => "#{@root}#{@conjugations[person]}")
      else
        buffer
      end
    end
  end

  def irregular_forms
    exceptions = @exceptions.select { |match, _| @infinitive.match(match) }.values
    case exceptions.length
    when 0 then {}
    when 1
      exceptions[0].reduce(Hash.new) do |conjugations, (conjugation, value)|
        if @exceptions.select { |match, _| @infinitive.match(match) }.keys[0].is_a?(String) ## refactor
          value = value # If it's a string, we're providing full forms.
        else # regexp
          value = value.is_a?(Proc) ? value.call(@root) : "#{@root}#{value}"
        end
        conjugations.merge(conjugation => value)
      end
    else
      raise "There can't be more than 1 exception! #{exceptions.inspect}"
    end
  end

  def forms
    self.regular_forms.merge(self.irregular_forms)
  end

  def exception(match, forms)
    @exceptions[match] = forms
  end

  def regular?
    self.irregular_forms.empty?
  end

  def irregular?
    ! self.regular?
  end

  # Verb.new('buscar').past.exception?(:yo) # => true
  # TODO: Support usted/ustedes.
  def exception?(form)
    !! self.irregular_forms[form]
  end
end
