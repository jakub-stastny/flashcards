require 'flashcards/core_exts'

# verb = Flashcards.app.language.load_verb(app, 'hablar')
# verb.presente.nosotros
#
# verb = Flashcards.app.language._verb('tener', present: {yo: 'tengo', tú: 'tienes', él: 'tiene'})
# verb.presente.yo
module Flashcards
  class Language
    def self.languages
      @languages ||= Hash.new
    end

    def self.define(name, &block)
      self.languages[name] ||= self.new(name)
      self.languages[name].instance_eval(&block)
    end

    attr_reader :name
    def initialize(name)
      @name, @grammar_rules = name, Hash.new
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
    def _verb(infinitive, conjugation_groups)
      Verb.new(self, infinitive, @grammar_rules[:conjugation_groups], conjugation_groups)
    end

    attr_accessor :flashcards
    def flashcards
      @flashcards ||= Flashcards::Collection.new(Flashcard, @name.to_s) # Without any filters.
    end

    def load_verb(app, infinitive)
      flashcard = self.flashcards.find do |flashcard|
        flashcard.expressions.include?(infinitive)
      end

      flashcard.with(app).verb if flashcard
    end

    def say_voice(voice)
      @voice = voice
    end

    def syllabifier(syllabifier = nil)
      syllabifier ? @syllabifier = syllabifier : @syllabifier
    end

    def say_aloud(text)
      system("say -v #{@voice} #{text}")
    end

    def accents_help(text = nil)
      @text ||= text
    end
  end

  class Verb
    using CoreExts
    using RR::ColourExts

    attr_reader :infinitive
    def initialize(language, infinitive, conjugation_groups, conjugation_groups_2 = Hash.new)
      @language = language
      extra_keys = conjugation_groups_2.keys - conjugation_groups.keys
      unless extra_keys.empty?
        raise ArgumentError.new("The following tenses are not supported: #{extra_keys.inspect}")
      end

      @infinitive = infinitive
      @conjugation_groups = conjugation_groups.keys

      # For debug.
      @cg1, @cg2 = conjugation_groups, conjugation_groups_2

      conjugation_groups.each do |group_name, callable|
        define_singleton_method(group_name) do
          if conjugation_groups_2[group_name]
            # OK, this is controversial ... here we're allowing to redefine the infinitive.
            # As for the present conjugations of ir, we use the infinitive var.
            # This way only voy is irregular.
            # TODO: Should ve store both?
            infinitive = conjugation_groups_2[group_name][:infinitive] || @infinitive
            tense = callable.call(self, infinitive)
            # NOTE: In the following line, it really is @infinitive, not infinitive, otherwise we end up with vayir for ir imperativo_positivo.
            tense.irregular(@infinitive, conjugation_groups_2[group_name].except(:infinitive))
            # if group_name == :imperativo_positivo
            #   require 'pry'; binding.pry ###
            # end
            tense
          else
            callable.call(self, @infinitive)
          end
        end
      end
    end

    def show_forms
      self.forms.map do |group_name, conjugations|
        "<magenta.bold>#{group_name}</magenta.bold>\n#{self.send(group_name).show_forms}".colourise
      end.join("\n\n")
    end

    def forms
      @conjugation_groups.reduce(Hash.new) do |forms, group_name|
        forms.merge(group_name => self.send(group_name).forms)
      end
    end
  end

  class Tense
    # require 'flashcards/core_exts'
    # using RR::StringExts
    using RR::ColourExts

    attr_reader :tense, :forms, :stem, :infinitive
    def initialize(language, tense, infinitive, &block)
      @language = language
      @tense, @infinitive = tense, infinitive
      @delegations = Hash.new
      @stem, @conjugations = self.instance_eval(&block)

      # ir is not really stem ... so yeah, can be nil.
      # raise ArgumentError.new("Root for #{@infinitive} has to be present.") unless @stem.is_a?(String)
      unless @conjugations.is_a?(Hash)
        raise ArgumentError.new("Conjugations for #{@infinitive} have to be defined.\nInspect: #{@conjugations.inspect}")
      end

      unless @conjugations.keys.all? { |key| key.is_a?(Symbol) }
        raise TypeError.new(@conjugations.keys.inspect)
      end

      unless @conjugations.values.all? { |key|
        key.is_a?(String) ||
        ((key.is_a?(Array) && key.all? { |i| i.is_a?(String) })) ||
        (key.is_a?(Hash) && key.keys.include?(:stem) && key.keys.include?(:ending)) ||
        key == :delegated }
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

    # Is it where we should do this - (-se)?
    def infinitive
      @infinitive.sub(/se$/, '')
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
              buffer.merge(person => ending_or_endings.map { |ending| xxxxx("#{@stem}#{ending}") })
            elsif ending_or_endings.is_a?(Hash)
              buffer.merge(person => "#{ending_or_endings[:stem]}#{ending_or_endings[:ending]}")
            elsif ending_or_endings.is_a?(String)
              buffer.merge(person => xxxxx("#{@stem}#{ending_or_endings}"))
            else
              raise TypeError.new("#{@tense}: #{ending_or_endings.inspect}")
            end
          end
        else
          buffer
        end
      end
    end

    def xxxxx(word) # TODO: Unless it's an exception, like dé.
      # We have to use deaccentuate, because deis/déis. The latter is 2 syllables.
      @language.syllabifier.syllables(@language.syllabifier.deaccentuate(word)).length == 1 ? @language.syllabifier.deaccentuate(word) : word
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
            value = value.is_a?(Proc) ? value.call(@stem) : "#{@stem}#{value}"
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

    def show_forms
      lines = Array.new

      self.pretty_inspect.transpose.each do |row_items|
        lines << row_items.map.with_index { |item, index|
          colour = item[:exception] ? 'red' : 'green'
          width = self.pretty_inspect[index].max_by { |item| item[:conjugation].length }[:conjugation].length
          "<#{colour}>#{item[:conjugation]}#{' ' * (width - item[:conjugation].length)}</#{colour}>"
        }.join(' | ').colourise
      end

      lines
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
