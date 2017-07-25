require 'flashcards'
require 'flashcards/core_exts'
require 'flashcards/testers/command_line'

module Flashcards
  module Commander
    using CoreExts
    using RR::ColourExts

    # TODO: Open (the single YAML) in Vim to force me to add the examples immediately.
    def self.add(argv)
      args, tags = argv.group_by { |x| x.start_with?('#') }.values
      if args.length == 1 # TODO: Also can be flashcards pl kurwa, 2 args, clashes with the following. Test if the first argument is the language code.
        flashcards = Flashcards::Flashcard.load(:es) # FIXME
        matching_flashcards = flashcards.select do |flashcard|
          flashcard.expressions.include?(args[0])
        end
        if matching_flashcards.empty?
          puts "There is no definition for #{args[0]} yet."
        else
          puts "<magenta>Matching flashcards:</magenta>\n- #{matching_flashcards.map { |f| "<yellow>#{f.expressions.join_with_and}</yellow>: #{f.translations.join_with_and}" }.join("\n- ")}".colourise
        end
      elsif args.length == 2 || args.length == 3
        flashcard = Flashcard.new(
          expression: args[-2].split(','),
          translations: args[-1].split(','),
          tags: (tags || Array.new).map { |tag| tag[1..-1].to_sym },
          examples: [
            Example.new(expression: 'Expression.', translation: 'Translation.'),
            Example.new(expression: 'Expression.', translation: 'Translation.')
          ]
        )

        self.add_flashcard((args.length == 3) ? args[0] : nil, flashcard)
      else
        # TODO: Commander::HELP_ITEMS[:add]
        abort "Usage: #{File.basename($0)} [lang] [word] [translation] [tags]"
      end
    end

    def self.add_flashcard(language_name, new_flashcard)
      Flashcards.app(language_name).load_do_then_save do |flashcards|
        unless flashcards.find { |flashcard| flashcard == new_flashcard }
          flashcards << new_flashcard
        else
          # FIX: /Users/botanicus/Dropbox/Projects/Software/flashcards/lib/flashcards/commander.rb:25:in `block in add_flashcard': undefined method `titlecase' for "already":String (NoMethodError)
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

    def self.console
      flashcards = Flashcards::Flashcard.load(:es)
      tests = Flashcards::Test.load(:es)
      # Flashcards::Flashcard.save(:es, flashcards)
      require 'pry'; binding.pry
    end

    def self.edit(argv)
      editor = ENV['EDITOR'] || 'vim'
      exec "#{editor} #{Flashcards.app(argv.first).flashcard_file}"
    end

    # TODO: Take in consideration conjugations.
    def self.stats
      Flashcards.app.load do |flashcards|
        x= flashcards.select { |flashcard| flashcard.tags.include?(:irregular) }

        puts <<-EOF.colourise(bold: true)
<red>Stats</red>

<bold>Total flashcards</bold>: <green>#{flashcards.length}</green>.
<bold>You remember</bold>: <green>#{flashcards.count { |flashcard| flashcard.correct_answers[:default].length > 2 }}</green> (ones that you answered correctly 3 times or more).

<bold>Ready for review</bold>: <blue>#{flashcards.count(&:time_to_review?)}</blue>.
<bold>To be reviewed later</bold>: <blue>#{flashcards.count { |flashcard| ! flashcard.should_run? }}</blue>.
<bold>Comletely new</bold>: <blue>#{flashcards.count(&:new?)}</blue>.
        EOF
      end
    end

    def self.verify
      require 'flashcards/wordreference'

      Flashcards.app.load_do_then_save do |flashcards| # TODO: Save once it's stable.
        flashcards_with_unknown_attributes = flashcards.select do |flashcard|
          ! flashcard.unknown_attributes.empty?
        end

        unless flashcards_with_unknown_attributes.empty?
          flashcards_with_unknown_attributes.each do |flashcard|
            warn "~ <yellow>#{flashcard.expressions.first}</yellow> has these unknown attributes: <yellow>#{flashcard.unknown_attributes.join_with_and}</yellow>.".colourise
          end
          puts;
        end

        begin
          Flashcards::WordReference.run(flashcards)
        rescue SocketError
          abort "<red>Internet connection is required for this command to run.</red>".colourise
        end

        # Save the flashcards with updated metadata.
        flashcards.map(&:data)
      end
    end

    def self.has_not_run_today
      Flashcards.app.load do |flashcards|
        to_be_reviewed = flashcards.count(&:time_to_review?)
        new_flashcards = flashcards.count(&:new?)

        exit 1 if (to_be_reviewed + new_flashcards) == 0

        last_review_at = flashcards.map { |f| f.correct_answers.values.flatten.sort.last }.compact.sort.last

        run_today = last_review_at && last_review_at.to_date == Date.today
        exit 1 if run_today
      end
    end

    def self.run(language = nil)
      Flashcards.app(language.to_sym) if language

      Flashcards.app.load_do_then_save do |flashcards|
        begin
          Flashcards::CommnandLineTester.new(
            flashcards,
            Flashcards.app.language,
            Flashcards.app.config
          ).run
        rescue Interrupt, EOFError
          puts # Quit the test mode, the progress will be saved.
        end

        # Save the flashcards with updated metadata.
        flashcards.map(&:data)
      end
    end
  end
end
