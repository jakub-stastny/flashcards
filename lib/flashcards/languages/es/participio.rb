# frozen_string_literal: true

Flashcards::Language.define(:es) do
  conjugation_group(:participio) do |verb, infinitive|
    tense = Flashcards::Tense.new(self, :participio, infinitive) do
      case self.infinitive
      when /^(.+)ar(se)?$/
        [Regexp.last_match(1), default: 'ado']
      when /^(.*)[ei]r(se)?$/
        [Regexp.last_match(1), default: 'ido']
      end
    end

    tense
  end
end
