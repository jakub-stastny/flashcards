# Positive, negative & vos.

# Are there formal nosotros commands?
# => Sloucit into one imperative unless nosotros or que commands clashes, but I doubt that.

# require 'flashcards/core_exts'
# using RR::StringExts

# {yo: 'o'} vs. {yo: "#{root}o"} ? Since here we want to proxy, so we don't have to duplicate exceptions.
# {yo: 'o'} or also(!) {tú: delegate(verb.subjunctive, :él)}
#   Maybe :o, but 'tengo'.
#   How to proxy #exception?(person) ?

# Imperative:
#   ProxyTense.new(Flashcards.app.language.verb('hablar').presente, :él, :tú)
#
# class ProxyTense
#   def initialize(tense, pronoun, pronoun_accessor = pronoun)
#     @tense, @pronoun = tense, pronoun
#
#     define_singleton_method(pronoun_accessor) do
#       @tense.send(@pronoun)
#     end
#   end
#
#   def exception?
#     @tense.exception?(@pronoun)
#   end
# end

require_relative './formal'

Flashcards.app.define_language(:es) do
  conjugation_group(:imperativo_positivo) do |infinitive|
    Flashcards::Tense.new(:imperativo_positivo, infinitive) do
      verb = Flashcards.app.language.verb(infinitive)
      root = infinitive[0..-3]

      [root, {
        tú: verb.presente.él,
        vos: infinitive.sub(/(.)r$/) {
          accented_character = {'a' => 'á', 'e' => 'é', 'i' => 'í'}[$1]
          # "#{root}#{accented_character}s"
          "#{$`}|#{accented_character}s"
          "#{accented_character}"
        },
        # trabajar -> trabajemos, trabajAD, trabajen
        # vivir    -> vivamos, vivID, vivan
        # comer    -> comamos, comed, coman
        #   ... with the exception of vosotros, it's the subjunctive.
        #
        # nosotros: verb.presente.nosotros,
        vosotros: "#{root}#{infinitive[-2]}d"
      }]
    end
  end
end

Flashcards.app.define_language(:es) do
  conjugation_group(:imperativo_negativo) do |infinitive|
    tense = Flashcards::Tense.new(:imperativo_negativo, infinitive) do
      verb = Flashcards.app.language.verb(infinitive)
      root = infinitive[0..-3]

      [root, {
        tú: "#{verb.imperativo_formal.usted}s",
        # nosotros: "#{verb.imperativo_formal.tú.ending}s",
        # vosotros: "#{verb.imperativo_formal.tú.ending}s"
      }]
    end

    tense.alias_person :vos, :tú

    tense
  end
end
