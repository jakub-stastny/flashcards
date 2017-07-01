# Affirmative and negative commands are the same (¡Hable! and ¡No hable!).
Flashcards.app.define_language(:es) do
  conjugation_group(:imperativo_formal) do |infinitive|
    Flashcards::Tense.new(:imperativo_formal, infinitive) do
      case infinitive
      when /^(.+)ar$/
        [$1, {
          usted: 'e', ustedes: 'en'
        }]
      when /^(.+)[ei]r$/
        [$1, {
           usted: 'a', ustedes: 'an'
        }]
      end
    end
  end
end
