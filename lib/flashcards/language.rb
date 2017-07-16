# verb = Flashcards.app.language.load_verb('hablar')
# verb.presente.nosotros
#
# verb = Flashcards.app.language._verb('tener', present: {yo: 'tengo', tú: 'tienes', él: 'tiene'})
# verb.presente.yo
module Flashcards
  class Language
    attr_reader :name
    def initialize(name, config)
      @name, @config, @grammar_rules = name, config, Hash.new
    end

    def conjugation_group(name, &block)
      # conjugation_group = block.call
      # raise ArgumentError unless conjugation_group.is_a?(Tense)
      @grammar_rules[:conjugation_groups] ||= Hash.new
      @grammar_rules[:conjugation_groups][name] = block
    end

    def conjugation_groups
      @grammar_rules[:conjugation_groups].keys
    end

    # You probably want to use load_verb instead.
    def _verb(infinitive, conjugation_groups = Hash.new)
      Verb.new(infinitive, @grammar_rules[:conjugation_groups], conjugation_groups)
    end

    def flashcards
      @flashcards ||= Flashcards::Flashcard.load(@name)
    end

    def load_verb(infinitive)
      self.flashcards.find do |flashcard|
        flashcard.expressions.include?(infinitive)
      end.verb
    end

    def say_voice(voice)
      @voice = voice
    end

    def say_aloud(text)
      system("say -v #{@voice} #{text}")
    end
  end

  class Verb
    attr_reader :infinitive
    def initialize(infinitive, conjugation_groups, conjugation_groups_2 = Hash.new)
      extra_keys = conjugation_groups_2.keys - conjugation_groups.keys
      unless extra_keys.empty?
        raise ArgumentError.new("The following tenses are not supported: #{extra_keys.inspect}")
      end

      @infinitive = infinitive
      conjugation_groups.each do |group_name, callable|
        define_singleton_method(group_name) do
          if conjugation_groups_2[group_name]
            tense = callable.call(infinitive)
            tense.irregular(infinitive, conjugation_groups_2[group_name])
            tense
          else
            callable.call(infinitive)
          end
        end
      end
    end

    def show_forms
      puts <<-EOF
Participle: #{self.participio.default}
Gerund: #{self.gerundio.default}

Vos presente: #{self.presente.vos}
Vos imperativo: #{self.imperativo_positivo.vos}

# Present
yo #{self.presente.yo}
tú #{self.presente.tú}
él #{self.presente.él}
nosotros #{self.presente.nosotros}
vosotros #{self.presente.vosotros}
ellos #{self.presente.ellos}

# Preterit
yo #{self.pretérito.yo}
tú #{self.pretérito.tú}
él #{self.pretérito.él}
nosotros #{self.pretérito.nosotros}
vosotros #{self.pretérito.vosotros}
ellos #{self.pretérito.ellos}

# Imperfect
yo #{self.imperfecto.yo}
tú #{self.imperfecto.tú}
él #{self.imperfecto.él}
nosotros #{self.imperfecto.nosotros}
vosotros #{self.imperfecto.vosotros}
ellos #{self.imperfecto.ellos}

# Conditional
yo #{self.condicional.yo}
tú #{self.condicional.tú}
él #{self.condicional.él}
nosotros #{self.condicional.nosotros}
vosotros #{self.condicional.vosotros}
ellos #{self.condicional.ellos}

# Future
yo #{self.futuro.yo}
tú #{self.futuro.tú}
él #{self.futuro.él}
nosotros #{self.futuro.nosotros}
vosotros #{self.futuro.vosotros}
ellos #{self.futuro.ellos}

# Imperative
tú #{self.imperativo_positivo.tú}
usted #{self.imperativo_formal.usted}
nosotros #{self.imperativo_positivo.nosotros}
vosotros #{self.imperativo_positivo.vosotros}
ustedes #{self.imperativo_formal.ustedes}

# Subjunctive
yo #{self.subjunctivo.yo}
tú #{self.subjunctivo.tú}
él #{self.subjunctivo.él}
nosotros #{self.subjunctivo.nosotros}
vosotros #{self.subjunctivo.vosotros}
ellos #{self.subjunctivo.ellos}

# Subjunctive Imperfect
yo #{self.subjunctivo_imperfecto.yo[0]}
tú #{self.subjunctivo_imperfecto.tú[0]}
él #{self.subjunctivo_imperfecto.él[0]}
nosotros #{self.subjunctivo_imperfecto.nosotros[0]}
vosotros #{self.subjunctivo_imperfecto.vosotros[0]}
ellos #{self.subjunctivo_imperfecto.ellos[0]}

# Subjunctive Imperfect 2
yo #{self.subjunctivo_imperfecto.yo[1]}
tú #{self.subjunctivo_imperfecto.tú[1]}
él #{self.subjunctivo_imperfecto.él[1]}
nosotros #{self.subjunctivo_imperfecto.nosotros[1]}
vosotros #{self.subjunctivo_imperfecto.vosotros[1]}
ellos #{self.subjunctivo_imperfecto.ellos[1]}

# Subjunctive Future
yo #{self.subjunctivo_futuro.yo}
tú #{self.subjunctivo_futuro.tú}
él #{self.subjunctivo_futuro.él}
nosotros #{self.subjunctivo_futuro.nosotros}
vosotros #{self.subjunctivo_futuro.vosotros}
ellos #{self.subjunctivo_futuro.ellos}
      EOF
    end
  end

  class Tense
    # require 'flashcards/core_exts'
    # using RR::StringExts

    attr_reader :tense, :forms, :root, :infinitive
    def initialize(tense, infinitive, &block)
      @tense, @infinitive = tense, infinitive
      @delegations = Hash.new
      @root, @conjugations = self.instance_eval(&block)

      # ir is not really root ... so yeah, can be nil.
      # raise ArgumentError.new("Root for #{@infinitive} has to be present.") unless @root.is_a?(String)
      unless @conjugations.is_a?(Hash)
        raise ArgumentError.new("Conjugations for #{@infinitive} have to be defined.")
      end

      unless @conjugations.keys.all? { |key| key.is_a?(Symbol) }
        raise TypeError.new(@conjugations.keys.inspect)
      end

      unless @conjugations.values.all? { |key| key.is_a?(String) || (key.is_a?(Array) && key.all? { |i| i.is_a?(String) }) || key == :delegated }
        raise TypeError.new(@conjugations.values.inspect)
      end

      @forms = @conjugations.keys
      @exceptions = Hash.new
      @aliased_persons = Hash.new

      @forms.each do |form|
        define_singleton_method(form) do
          self.forms[form]
        end
      end
    end

    def delegate(person, tense, pronoun, &transformation)
      @delegations[person] = [tense, pronoun, transformation]
      return :delegated
    end

    def regular_forms
      @forms.reduce(Hash.new) do |buffer, person|
        unless self.irregular_forms.include?(person)
          if delegation = @delegations[person]
            tense, pronoun, transformation = *delegation
            form = tense.send(pronoun)
            buffer.merge(person => transformation ? transformation.call(form) : form)
          else
            ending_or_endings = @conjugations[person]
            if ending_or_endings.is_a?(Array)
              buffer.merge(person => ending_or_endings.map { |ending| xxxxx("#{@root}#{ending}") })
            else
              buffer.merge(person => xxxxx("#{@root}#{ending_or_endings}"))
            end
          end
        else
          buffer
        end
      end
    end

    def xxxxx(word) # TODO: Unless it's an exception, like dé.
      # We have to use deaccentuate, because deis/déis. The latter is 2 syllables.
      Flashcards.syllables(Flashcards.deaccentuate(word)).length == 1 ? Flashcards.deaccentuate(word) : word
    end

    def irregular_forms
      exceptions = @exceptions.select { |match, _| @infinitive.match(match) }.values
      case exceptions.length
      when 0 then {}
      when 1
        exceptions[0].reduce(Hash.new) do |conjugations, (conjugation, value)|
          if @exceptions.select { |match, _| match.is_a?(String) ? @infinitive.match(/^#{match}$/) : @infinitive.match(match) }.keys[0].is_a?(String) ## refactor
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

    def irregular(match, forms)
      @exceptions[match] = forms
    end

    def regular?
      self.irregular_forms.empty?
    end

    def irregular?
      ! self.regular?
    end

    # Verb.new('buscar').past.irregular?(:yo) # => true
    def irregular?(form)
      form = @aliased_persons.invert[form] if @aliased_persons.invert[form]
      !! self.irregular_forms[form]
    end

    def pretty_inspect(*groups)
      groups.map do |persons|
        persons.map do |person|
          text = person && [self.send(person)].flatten.join(', ')
          {
            exception: person ? self.irregular?(person) : false,
            conjugation: person ? "#{person} #{text}" : ''
          }
        end
      end
    end

    def alias_person(new_person, aliased_person)
      @aliased_persons[aliased_person] = new_person

      (class << self; self; end).instance_eval do
        alias_method new_person, aliased_person
      end
    end
  end
end
