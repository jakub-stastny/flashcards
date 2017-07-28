require 'flashcards/command'

module Flashcards
  class RunCommand < SingleLanguageCommand
    self.help = <<-EOF
      flashcards <bright_black># Run it!</bright_black>
      flashcards <yellow>pl</yellow> <bright_black># Run it, Polish.</bright_black>
      <magenta.bold>FLASHCARDS=dar,estar</magenta.bold> flashcards <bright_black># Run it with a subset of defined flashcards.</bright_black>
    EOF

    def run
      self.set_language(language) if language
      puts "~ Using language <yellow>#{Flashcards.app.language.name}</yellow>.\n\n".colourise

      begin
        Flashcards::CommnandLineTester.new(
          Flashcards.app.flashcards,
          Flashcards.app.language,
          Flashcards.app.config
        ).run
      rescue Interrupt, EOFError
        puts # Quit the test mode, the progress will be saved.
      end
    end
  end
end
