Flashcards.app.define_language(:es) do
  conjugation_group(:participio) do |infinitive|
    tense = Flashcards::VerbForm.new(:participio, infinitive) do
      case infinitive
      when /^(.+)ar(se)?$/
        [$1, 'ado']
      when /^(.*)[ei]r(se)?$/
        [$1, 'ido']
      end
    end

    tense
  end
end
