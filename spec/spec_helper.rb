# frozen_string_literal: true

ENV['FLASHCARDS_CONFIG'] = File.expand_path('../data/config.yml', __FILE__)

RSpec.configure do |config|
  config.include(Module.new {
    def default_flashcards
      [
        Flashcards::Flashcard.new(expressions: ['hablar', 'hablarse'], translation: 'to speak', tags: [:verb]),
        Flashcards::Flashcard.new(expressions: ['comer', 'comerse'], translation: 'to eat', tags: [:verb]),
        Flashcards::Flashcard.new(expressions: ['vivir', 'vivirse'], translation: 'to live', tags: [:verb])
      ]
    end
  })
end
