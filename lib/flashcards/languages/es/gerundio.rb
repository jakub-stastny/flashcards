# hablar = Flashcards.app.language.verb('hablar')
# hablar.presente.yo
#
# hablar.gerundio.irregular?
# hablar.gerundio.to_s
Flashcards.app.define_language(:es) do
  conjugation_group(:gerundio) do |infinitive|
    tense = Flashcards::VerbForm.new(:gerundio, infinitive) do
      case infinitive
      when /^(.+)ar(se)?$/
        [$1, 'ando']
      when /^(.*)[ei]r(se)?$/
        [$1, 'iendo']
      end
    end

    tense.irregular(/^(.*[:vowel:])[ei]r(se)?$/, '') # => yendo

    tense
  end
end
