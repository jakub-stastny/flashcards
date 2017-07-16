require_relative '../subjuntivo/presente'

Flashcards.app.define_language(:es) do
  conjugation_group(:imperativo_formal) do |infinitive|
    tense = Flashcards::Tense.new(:imperativo_formal, infinitive) do
      verb = Flashcards.app.language.load_verb(infinitive)

      [infinitive, {
        usted:   delegate(:usted,   verb.subjuntivo, :usted),
        ustedes: delegate(:ustedes, verb.subjuntivo, :ustedes)
      }]
    end

    tense.define_singleton_method(:pretty_inspect) do
      super([:usted], [:ustedes])
    end

    tense
  end
end
