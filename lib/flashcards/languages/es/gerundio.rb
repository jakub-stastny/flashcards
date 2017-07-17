require_relative 'indicativo/presente'

Flashcards.app.define_language(:es) do
  conjugation_group(:gerundio) do |infinitive|
    tense = Flashcards::Tense.new(:gerundio, infinitive) do
      verb = Flashcards.app.language.load_verb(infinitive)
      stem = verb.pretérito.él.sub(/i?ó/, '')

      case infinitive
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
