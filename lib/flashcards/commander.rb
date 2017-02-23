require 'flashcards'

module Flashcards
  module Commander
    def self.add(argv)
      unless ARGV.length == 2
        abort "Usage: #{File.basename($0)} [word] [translation]"
      end

      flashcard = Flashcard.new(expression: argv[0], translations: argv[1].split(','))
      self.add_flashcard(flashcard)
    end

    def self.add_flashcard(new_flashcard)
      Flashcards.load_do_then_save do |flashcards|
        unless flashcards.find { |flashcard| flashcard == new_flashcard }
          flashcards << new_flashcard
        else
          warn "~ #{new_flashcard.translations.first} is already defined." ## TODO: move to the method above, return true/false and if it above.
        end

        flashcards.map(&:data)
      end
    end

    def self.reset
      Flashcards.load_do_then_save do |flashcards|
        flashcards.each { |flashcard| flashcard.metadata.clear }.map(&:data)
      end
    end

    def self.edit
      editor = argv.shift || ENV['EDITOR'] || abort('Either configure $EDITOR or pass an editor as an argument.')
      exec "#{editor} #{FLASHCARDS_DATA.path}"
    end

    def self.stats
      Flashcards._load do |flashcards|
        puts colourise(<<-EOF, bold: true)
<red>Stats:</red>
  Total flashcards: #{flashcards.length}.
  You remember: #{flashcards.count { |flashcard| flashcard.correct_answers.length > 2 }} (ones that you answered correctly 3 times or more).
  To be reviewed: #{flashcards.count(&:time_to_review?)}.
  Comletely new: #{flashcards.count(&:new?)}.
        EOF
      end
    end

    def self.run
      Flashcards.load_do_then_save do |flashcards|
        Flashcards.run(flashcards)

        # Save the metadata.
        flashcards.map(&:data)
      end
    end
  end
end
