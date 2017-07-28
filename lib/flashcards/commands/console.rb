require 'flashcards/command'

module Flashcards
  class ConsoleCommand < SingleLanguageCommand
    self.help = <<-EOF
      flashcards <magenta>console</magenta>
      flashcards <magenta>console</magenta> es
      flashcards <magenta>console</magenta> es hablar comer vivir 'el problema'
      # el problema -> el_problema
    EOF

    def run
      words = self.get_args(argv)
      puts "~ Using language <yellow>#{Flashcards.app.language.name}</yellow>.".colourise

      fs = Flashcards.app.flashcards
      ts = Flashcards.app.tests
      words.each do |word|
        if fs[:expressions, word].length == 1
          flashcard = fs[:expressions, word].first
          # I don't know how to set local variables in pry.
          define_singleton_method(word.tr(' ', '_')) { flashcard }
        else
          warn '...'
        end
      end
      require 'pry'; binding.pry
    end
  end
end
