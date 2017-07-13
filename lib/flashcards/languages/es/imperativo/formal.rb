# Affirmative and negative commands are the same (¡Hable! and ¡No hable!).
Flashcards.app.define_language(:es) do
  conjugation_group(:imperativo_formal) do |infinitive|
    tense = Flashcards::Tense.new(:imperativo_formal, infinitive) do
      case infinitive
      when /^(.+)ar(se)?$/
        [$1, {usted: 'e', ustedes: 'en'}]
      when /^(.*)[ei]r(se)?$/ # ir, irse
        [$1, {usted: 'a', ustedes: 'an'}]
      end
    end

    tense.define_singleton_method(:pretty_inspect) do
      super([:usted], [:ustedes])
    end

    tense
  end
end
