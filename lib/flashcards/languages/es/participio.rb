Flashcards.app.define_language(:es) do
  conjugation_group(:participio) do |infinitive|
    tense = Flashcards::Tense.new(:participio, infinitive) do
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
