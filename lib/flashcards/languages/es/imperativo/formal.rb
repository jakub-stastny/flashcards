# Affirmative and negative commands are the same (¡Hable! and ¡No hable!).
Flashcards.app.define_language(:es) do
  conjugation_group(:imperativo_formal) do |infinitive|
    Flashcards::Tense.new(:imperativo_formal, infinitive) do
      case infinitive
      when /^(.+)ar$/
        [$1, {
          usted: 'e', nosotros: 'TODO', ustedes: 'en'
        }]
      when /^(.+)[ei]r$/
        [$1, {
           usted: 'a', nosotros: 'TODO', ustedes: 'an'
        }]
      end
    end
  end
end
