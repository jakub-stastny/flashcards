require 'flashcards'
require 'flashcards/core_exts'
require 'flashcards/testers/command_line'

module Flashcards
  module Commander
    using CoreExts
    using RR::ColourExts
    using RR::StringExts # #titlecase

    # This is definitely not bullet-proof, (but at the moment it is sufficient for our needs).
    #
    # For instance: flashcards add de
    #
    # 1. Add to the German flashcards (de), incomplete arguments.
    # 2. Add to the default flashcards the word de (can be Spanish, from).
    def self.get_args(args)
      if Flashcards.defined_languages.include?(args[0])
        self.set_language(args[0]) # This is a setter (maybe it shouldn't be and we should just return it?)
        args[1..-1]
      else
        args
      end
    end

    def self.set_language(language)
      if Flashcards.defined_languages.include?(language.to_sym)
        Flashcards.app(language) # This is a setter (maybe it shouldn't be and we should just return it?)
      end
    end

    def self.add(argv)
      args = self.get_args(argv)
      args, tags = args.group_by { |x| x.start_with?('#') }.values
      if args.length == 1
        flashcards = Flashcards.app.flashcards

        matching_flashcards = flashcards.select do |flashcard|
          flashcard.expressions.include?(args[0])
        end

        if matching_flashcards.empty?
          puts "There is no definition for #{args[0]} yet."
        else
          puts "<magenta>Matching flashcards:</magenta>\n- #{matching_flashcards.map { |f| "<yellow>#{f.expressions.join_with_and}</yellow>: #{f.translations.join_with_and}" }.join("\n- ")}".colourise
        end
      elsif args.length == 2
        flashcards = Flashcards.app.flashcards

        expressions  = args[-2].split(/,\s*/)
        translations = args[-1].split(/,\s*/)

        flashcards.each do |flashcard|
          if (! (flashcard.expressions & expressions).empty?) && (! (flashcard.translations & translations).empty?)
            abort "Same flashcard: #{flashcard}.".colourise
          end
        end

        flashcard = Flashcard.new(
          expressions: expressions,
          translations: translations,
          tags: (tags || Array.new).map { |tag| tag[1..-1].to_sym },
          examples: [
            Example.new(expression: 'Expression 1.', translation: 'Translation 1.'),
            Example.new(expression: 'Expression 2.', translation: 'Translation 2.', label: 'Usage XYZ', tags: ['Spain'])
          ],
          metadata: {
            last_review_time: Time.now
          }
        )

        if flashcard = self.edit_flashcard(flashcard)
          flashcards << flashcard
          flashcards.save
        else
          abort "No data found."
        end
      else
        # TODO: Commander::HELP_ITEMS[:add]
        abort "Usage: #{File.basename($0)} [lang] [word] [translation] [tags]"
      end
    end

    def self.edit_flashcard(flashcard)
      path = "/tmp/#{flashcard.expressions.first.tr(' ', '_')}.yml"

      if File.exist?(path) # Give a chance to edit incorrect data.
        # TODO: Compare if anything changed.
        File.open(path, 'a') do |file|
          file.rewind
          file.puts("# NOTE: This file has been created at #{File.mtime(file)}.")
        end
      else
        File.open(path, 'w') do |file|
          file.puts(flashcard.data.to_yaml)
        end
      end

      system("vim #{path}")

      flashcard_data = YAML.load_file(path)

      File.unlink(path)

      return unless flashcard_data
      flashcard = Flashcard.new(flashcard_data)

      flashcard
    end

    def self.review(argv)
      args = self.get_args(argv)
      flashcards = Flashcards.app.flashcards
      flashcards.each do |flashcard|
        if (args[0] && flashcard.expressions.include?(args[0])) || args.empty?
          if new_flashcard = self.edit_flashcard(flashcard)
            new_flashcard.metadata[:last_review_time] = Time.now
            flashcards.replace(flashcard, new_flashcard)
            flashcards.save
          end
        end
      end
    end

    def self.reset(argv)
      self.set_language(argv[0]) if argv[0]
      puts "~ Using language <yellow>#{Flashcards.app.language.name}</yellow>.".colourise

      flashcards = Flashcards.app.flashcards
      flashcards.save # Make a back-up.
      flashcards.each { |flashcard| flashcard.metadata.clear }
      flashcards.save

      puts "~ Metadata has been reset. Back-up has been created beforehands."
    end

    def self.console(argv)
      self.set_language(argv[0]) if argv[0]
      puts "~ Using language <yellow>#{Flashcards.app.language.name}</yellow>.".colourise

      fs = Flashcards.app.flashcards
      ts = Flashcards.app.tests
      require 'pry'; binding.pry
    end

    # TODO: Take in consideration conjugations.
    def self.stats(argv)
      self.set_language(argv[0]) if argv[0]
      puts "~ Using language <yellow>#{Flashcards.app.language.name}</yellow>.".colourise

      flashcards = Flashcards.app.flashcards

      puts <<-EOF.colourise(bold: true)

<red>Stats</red>

<bold>Total flashcards</bold>: <green>#{flashcards.length}</green>.
<bold>You remember</bold>: <green>#{flashcards.count { |flashcard| flashcard.correct_answers[:default].length > 2 }}</green> (ones that you answered correctly 3 times or more).

<bold>Ready for review</bold>: <blue>#{flashcards.count(&:time_to_review?)}</blue>.
<bold>To be reviewed later</bold>: <blue>#{flashcards.count { |flashcard| ! flashcard.should_run? }}</blue>.
<bold>Comletely new</bold>: <blue>#{flashcards.count(&:new?)}</blue>.
        EOF
    end

    def self.verify(argv)
      self.set_language(argv[0]) if argv[0]
      puts "~ Using language <yellow>#{Flashcards.app.language.name}</yellow>.".colourise

      require 'flashcards/wordreference'

      flashcards = Flashcards.app.flashcards
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
      flashcards.save
    end

    def self.has_not_run_today
      flashcards = Flashcards.app.flashcards
      to_be_reviewed = flashcards.count(&:time_to_review?)
      new_flashcards = flashcards.count(&:new?)

      exit 1 if (to_be_reviewed + new_flashcards) == 0

      last_review_at = flashcards.map { |f| f.correct_answers.values.flatten.sort.last }.compact.sort.last

      run_today = last_review_at && last_review_at.to_date == Date.today
      exit 1 if run_today
    end

    def self.run(language = nil)
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
