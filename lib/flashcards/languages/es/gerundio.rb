Flashcards.app.define_language(:es) do
  conjugation_group(:gerundio) do |infinitive|
    tense = Flashcards::Tense.new(:gerundio, infinitive) do
      case infinitive
      when /^(.+)ar(se)?$/
        [$1, default: 'ando']
      when /^(.*)[ei]r(se)?$/
        [$1, default: 'iendo']
      end
    end

    vowels = Flashcards.app.language.syllabifier.vowels
    tense.irregular(/^(.*[#{vowels.join('')}])[ei]r(se)?$/, default: Proc.new { |stem| "#{stem}yendo" })

    tense.irregular(/(ll|ñ)[ei]r(se)?$/, default: Proc.new { |stem| "#{stem}endo" })

    tense
  end
end
