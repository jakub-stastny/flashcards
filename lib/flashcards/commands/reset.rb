require 'flashcards/command'

module Flashcards
  class ResetCommand < SingleLanguageCommand
    self.help = <<-EOF
      flashcards <green>reset</green> es<bright_black> # Reset metadata for given language.
      # Useful if you got someone else's file, and you want to reset his progress.</bright_black>
    EOF

    def run
      if argv.empty?
        abort "<red>ERROR:</red> You have to <bold>specify the language explicitly</bold>.\n       Your defined languages are #{Flashcards.defined_languages.join_with_and { |lang| "<yellow.bold>#{lang}</yellow.bold>" }}.".colourise
      end

      argv.each.with_index do |language_name, index|
        Flashcards.app(language_name)
        print "#{index > 0 ? "\n" : ""}~ Do you want to reset metadata of <red.bold>#{Flashcards.app.language.name}</red.bold>? [<red>y</red>/<green>n</green>] ".colourise
        if $stdin.readline.chomp.upcase == 'Y'
          flashcards = Flashcards.app.flashcards
          flashcards.save # Make a back-up. # FIXME: This won't work, as back-ups don't have seconds or rand in their names, so after the next save it will be overwritten.
          flashcards.each { |flashcard| flashcard.metadata.clear }
          flashcards.save
          puts "~ Metadata of <yellow>#{Flashcards.app.language.name}</yellow> has been reset. Back-up has been created beforehands.".colourise
        else
          puts "~ Skipping language <yellow>#{Flashcards.app.language.name}</yellow>.".colourise
        end
      end
    end
  end
end
