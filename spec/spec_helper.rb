class Hash
  def except(*keys)
    (self.keys - keys).reduce(self.class.new) do |buffer, key|
      buffer.merge(key => self[key])
    end
  end
end

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
