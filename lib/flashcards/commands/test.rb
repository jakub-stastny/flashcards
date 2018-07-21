# frozen_string_literal: true

require 'flashcards/command'

module Flashcards
  class TestCommand < SingleLanguageCommand
    using RR::ColourExts

    self.help = <<~EOF
      flashcards <red>test</red> <bright_black># Run it!</bright_black>
      flashcards <red>test</red> <yellow>pl</yellow> <bright_black># Run it, Polish.</bright_black>
      <magenta.bold>FLASHCARDS=dar,estar</magenta.bold> flashcards <red>test</red> <bright_black># Run it with a subset of defined flashcards.</bright_black>
    EOF

    def run
      app = self.get_app(@args[0])
      puts "~ Using language <yellow>#{app.language.name}</yellow>.\n\n".colourise

      begin
        Flashcards::CommnandLineTester.new(
          app,
          app.flashcards,
          app.language,
          app.config
        ).run
      rescue Interrupt, EOFError
        puts # Quit the test mode, the progress will be saved.
      end
    end
  end
end
