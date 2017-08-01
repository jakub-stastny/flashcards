require_relative '../subjuntivo/presente'

Flashcards::Language.define(:es) do
  conjugation_group(:imperativo_formal) do |verb, infinitive|
    tense = Flashcards::Tense.new(self, :imperativo_formal, infinitive) do
      [verb.subjuntivo.stem, {
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
