require 'flashcards/config'

# verb = Flashcards.language.verb.new('hablar')
# puts verb.present.nosotros
module Flashcards
  class Language
    def initialize(name, config)
      @name, @config, @grammar_rules = name, config, Hash.new
    end

    def conjugation_group(name, &block)
      # conjugation_group = block.call
      # raise ArgumentError unless conjugation_group.is_a?(Tense)
      @grammar_rules[:conjugation_groups] ||= Hash.new
      @grammar_rules[:conjugation_groups][name] = block
    end

    def verb(infinitive)
      Verb.new(infinitive, @grammar_rules[:conjugation_groups])
    end
  end

  class Verb
    attr_reader :infinitive, :conjugation_groups
    def initialize(infinitive, conjugation_groups)
      @infinitive, @conjugation_groups = infinitive, conjugation_groups
      @conjugation_groups.each do |group_name, callable|
        define_singleton_method(group_name) do
          callable.call(infinitive)
        end
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
    # TODO: change to PERSONS = SINGULAR_PERSONS + PLURAL_PERSONS.

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
end