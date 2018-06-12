# frozen_string_literal: true

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

      new_flashcard_count = app.flashcards.count { |flashcard| flashcard.tags.include?(:new) }

      case new_flashcard_count
      when 0            then test
      when 1..12        then review(3)  and test
      when 12..(5 * 12) then review(6)  and test
      else                   review(12) end
    end

    def test
      command = Flashcards::TestCommand.new(@args)
      command.run
    end

    def review(count)
      ENV['LIMIT'] = count.to_s
      command = Flashcards::ReviewCommand.new(@args)
      command.run
    end
  end
end
