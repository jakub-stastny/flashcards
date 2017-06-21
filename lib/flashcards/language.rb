# verb = Flashcards.app.language.verb('hablar')
# verb.presente.nosotros
#
# verb = Flashcards.app.language.verb('tener', present: {yo: 'tengo', tú: 'tienes', él: 'tiene'})
# verb.presente.yo
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

    def conjugation_groups
      @grammar_rules[:conjugation_groups].keys
    end

    def verb(infinitive, conjugation_groups = Hash.new)
      Verb.new(infinitive, @grammar_rules[:conjugation_groups], conjugation_groups)
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
            tense.exception(infinitive, conjugation_groups_2[group_name])
            tense
          else
            callable.call(infinitive)
          end
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
      @aliased_persons = Hash.new
      @forms.each do |form|
        define_singleton_method(form) do
          self.forms[form]
        end
      end
    end

    def regular_forms
      @forms.reduce(Hash.new) do |buffer, person|
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
    def exception?(form)
      form = @aliased_persons.invert[form] if @aliased_persons.invert[form]
      !! self.irregular_forms[form]
    end

    def alias_person(new_person, aliased_person)
      @aliased_persons[aliased_person] = new_person

      (class << self; self; end).instance_eval do
        alias_method new_person, aliased_person
      end
    end
  end
end
