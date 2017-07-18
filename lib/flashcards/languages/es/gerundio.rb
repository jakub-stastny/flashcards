require_relative 'indicativo/presente'

# Irregular:
# 1/ Direct exception.
#   a) In the stem (i. e. ir -> v-).
#   b) In the ending (i. e. ten-go).
#   c) In the ending and the stem (i. e. v-oy).
# 2/ Exception defined by a rule.
#   a) In the stem (i. e. buscar: busqu- instead of busc-).
#   b) In the ending (i. e. _______________).
#   c) In the ending and the stem (i. e. _______________). tense.stem won't reflect.
#
# Types of changes:
# 1/ change (dormir -> duermo, busc- -> busqu-).
# 2/ addition (tengo).
#
# presente:
#   stem: v
#   yo: voy

Flashcards.app.define_language(:es) do
  conjugation_group(:gerundio) do |verb|
    tense = Flashcards::Tense.new(:gerundio, verb.infinitive) do
      stem = verb.pretérito.él.sub(/i?ó/, '')

      case self.infinitive
      when /^(.+)ar(se)?$/
        [stem, default: 'ando']
      when /^(.*)[ei]r(se)?$/
        [stem, default: 'iendo']
      end
    end

    vowels = Flashcards.app.language.syllabifier.vowels
    tense.irregular(/^(.*[#{vowels.join('')}])[ei]r(se)?$/, default: Proc.new { |stem| "#{stem}yendo" })

    tense.irregular(/(ll|ñ)[ei]r(se)?$/, default: Proc.new { |stem| "#{stem}endo" })

    tense
  end
end
