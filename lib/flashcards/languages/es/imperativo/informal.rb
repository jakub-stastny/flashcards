# Positive, negative & vos.

# Are there formal nosotros commands?
# Names of these tenses.

# require 'flashcards/core_exts'
# using RR::StringExts

# {yo: 'o'} vs. {yo: "#{root}o"} ? Since here we want to proxy, so we don't have to duplicate exceptions.
#   Maybe :o, but 'tengo'.
#   How to proxy #exception?(person) ?

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
        # nosotros: verb.presente.nosotros,
        # vosotros: verb.presente.vosotros
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
  end
end
