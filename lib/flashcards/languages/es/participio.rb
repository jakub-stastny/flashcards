Flashcards.app.define_language(:es) do
  conjugation_group(:participio) do |verb|
    tense = Flashcards::Tense.new(:participio, verb.infinitive) do
      case infinitive
      when /^(.+)ar(se)?$/
        [$1, default: 'ado']
      when /^(.*)[ei]r(se)?$/
        [$1, default: 'ido']
      end
    end

    tense
  end
end
