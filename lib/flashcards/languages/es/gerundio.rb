# hablar = Flashcards.app.language.verb('hablar')
# hablar.presente.yo
#
# hablar.gerundio.irregular?
# hablar.gerundio.default
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

    # tense.irregular(/^(.*[:vowel:])[ei]r(se)?$/, '') # => yendo

    tense
  end
end
