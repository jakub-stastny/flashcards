require_relative '../subjuntivo/presente'

Flashcards.app.define_language(:es) do
  conjugation_group(:imperativo_formal) do |infinitive|
    tense = Flashcards::Tense.new(:imperativo_formal, infinitive) do
      verb = Flashcards.app.language.verb(infinitive)

      [infinitive, {
        usted:   delegate(:usted,   verb.subjunctivo, :usted),
        ustedes: delegate(:ustedes, verb.subjunctivo, :ustedes)
      }]
    end

    tense.define_singleton_method(:pretty_inspect) do
      super([:usted], [:ustedes])
    end

    tense
  end
end
