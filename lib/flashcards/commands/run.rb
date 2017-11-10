require 'flashcards/command'
require 'flashcards/commands/test'
require 'flashcards/commands/review'

module Flashcards
  class RunCommand < SingleLanguageCommand
    using RR::ColourExts

    self.help = <<-EOF.gsub(/^\s*/, '')
      flashcards <bright_black># Run it!</bright_black>
      flashcards <yellow>pl</yellow> <bright_black># Run it, Polish.</bright_black>
      <magenta.bold>FLASHCARDS=dar,estar</magenta.bold> flashcards <bright_black># Run it with a subset of defined flashcards.</bright_black>
    EOF

    def run
      app = self.get_app(@args[0])
      puts "~ Using language <yellow>#{app.language.name}</yellow>.\n\n".colourise

      if app.flashcards.count { |flashcard| flashcard.tags.include?(:new) } >= 10
        command = Flashcards::ReviewCommand.new(@args)
      else
        command = Flashcards::TestCommand.new(@args)
      end

      command.run
    end
  end
end
