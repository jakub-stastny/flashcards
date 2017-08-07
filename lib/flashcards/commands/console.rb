require 'flashcards/command'
require 'refined-refinements/colours'

module Flashcards
  class ConsoleCommand < SingleLanguageCommand
    using RR::ColourExts

    self.help = <<-EOF
      flashcards <magenta>console</magenta>
      flashcards <magenta>console</magenta> es
      flashcards <magenta>console</magenta> es hablar comer vivir 'el problema'
      # el problema -> el_problema
    EOF

    def run
      app, words = self.get_args(@args)
      puts "~ Using language <yellow>#{app.language.name}</yellow>.".colourise

      fs = app.flashcards
      ts = app.tests
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
