require 'flashcards/verb'

describe Flashcards do
  describe '.language' do
    it 'xxx' do
      p described_class.language
      p described_class.languages
      p described_class.language.verb('hablar')
      p described_class.language.verb('hablar').present
      p described_class.language.verb('hablar').present.yo
      p described_class.language.verb('hablar').past.yo
    end
  end
end
