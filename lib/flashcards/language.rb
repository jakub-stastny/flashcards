# verb = Flashcards.app.language.verb('hablar')
# verb.presente.nosotros
#
# verb = Flashcards.app.language.verb('tener', present: {yo: 'tengo', tú: 'tienes', él: 'tiene'})
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

    def verb(infinitive, conjugation_groups = Hash.new)
      Verb.new(infinitive, @grammar_rules[:conjugation_groups], conjugation_groups)
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
              buffer.merge(person => ending_or_endings.map { |ending| "#{@root}#{ending}" })
            else
              buffer.merge(person => "#{@root}#{ending_or_endings}")
            end
          end
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
          text = [self.send(person)].flatten.join(', ')
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
