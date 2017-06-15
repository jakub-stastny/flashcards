require 'flashcards'
require 'flashcards/core_exts'

module Flashcards
  module Commander
    using CoreExts
    using RR::ColourExts

    def self.add(argv)
      args, tags = argv.group_by { |x| x.start_with?('#') }.values
      unless args.length == 2 || args.length == 3
        # TODO: Commander::HELP_ITEMS[:add]
        abort "Usage: #{File.basename($0)} [lang] [word] [translation] [tags]"
      end

      flashcard = Flashcard.new(expression: args[-2].split(','), translations: args[-1].split(','), tags: tags)
      self.add_flashcard((args.length == 3) ? args[0] : nil, flashcard)
    end

    def self.add_flashcard(language_name, new_flashcard)
      Flashcards.app(language_name).load_do_then_save do |flashcards|
        unless flashcards.find { |flashcard| flashcard == new_flashcard }
          flashcards << new_flashcard
        else
          warn "~ #{new_flashcard.translations.first.titlecase} is already defined." ## TODO: move to the method above, return true/false and if it above.
        end

        flashcards.map(&:data)
      end
    end

    def self.reset
      Flashcards.app.load_do_then_save do |flashcards|
        flashcards.each { |flashcard| flashcard.metadata.clear }.map(&:data)
      end
    end

    def self.edit(argv)
      editor = ENV['EDITOR'] || abort('Please set $EDITOR.')
      exec "#{editor} #{Flashcards.app(argv.first).flashcard_file}"
    end

    def self.stats
      Flashcards.app._load do |flashcards|
        puts <<-EOF.colourise(bold: true)
<red>Stats:</red>
  Total flashcards: #{flashcards.length}.
  You remember: #{flashcards.count { |flashcard| flashcard.correct_answers.length > 2 }} (ones that you answered correctly 3 times or more).
  To be reviewed: #{flashcards.count(&:time_to_review?)}.
  Comletely new: #{flashcards.count(&:new?)}.
        EOF
      end
    end

    def self.has_not_run_today
      Flashcards.app._load do |flashcards|
        to_be_reviewed = flashcards.count(&:time_to_review?)
        new_flashcards = flashcards.count(&:new?)

        exit 1 if (to_be_reviewed + new_flashcards) == 0

        last_review_at = flashcards.map { |f| (f.metadata[:correct_answers] || Array.new).last }.compact.sort.last

        run_today = last_review_at && last_review_at.to_date == Date.today
        exit 1 if run_today
      end
    end

    def self.run
      Flashcards.app.load_do_then_save do |flashcards|
        Flashcards.app.run(flashcards)

        # Save the metadata.
        flashcards.map(&:data)
      end
    end
  end
end
