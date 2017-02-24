# At the moment this is Spanish-only.
# It's easy to add different set of rules, but since we got rid off <lang>: flashcards,
# we don't really know which set of rules to apply.

# verb = Flashcards.language.verb.new('hablar')
# puts verb.present.nosotros
module Flashcards
  class Language
    def initialize(name)
      @name = name
    end

    def verb
      # TODO:
    end
  end

  def self.languages
    @languages ||= Hash.new
  end

  def self.language(language_name = nil)
    language_config = self.config.language(language_name)
    require "flashcards/languages/#{language_config.name}"
    self.languages[language_config.name]
  rescue LoadError # Unsupported language.
    Language.new
  end

  def self.define_language(name, &block)
    self.languages[name] = Language.new(name)
    self.languages[name].instance_eval(&block)
  end

  class Verb
    def initialize(infinitive)
      @infinitive = infinitive
    end

    def tenses
      [self.present, self.past]
    end

    def present
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
