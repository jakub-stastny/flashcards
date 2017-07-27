require 'flashcards'
require 'flashcards/core_exts'
require 'flashcards/testers/command_line'

# TODO: Any command invocation should call auto_gc before to remove old backups.
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

    # TODO: This could get data from WR.
    def self.add(argv)
      args = self.get_args(argv)
      args = args.group_by do |item|
        case item
        when /^-/ then :args
        when /^#/ then :tags
        else :values end
      end

      args.default_proc = Proc.new { |hash, key| hash[key] = Array.new }

      if args[:values].empty?
        puts "<blue.bold>Usage</blue.bold>: <green>expression 1, expression 2</green> <magenta>=</magenta> <green>translation 1, translation 2</green> <yellow>#tags</yellow>\n\n".colourise
        puts "Press <bold>Esc</bold> for the command mode.\n\n".colourise
        loop do
          print "> "
          line = $stdin.readline.chomp
          values, tags = line.split(/\s+/).group_by { |word| word.match(/^#/) }.values
          values = values.join(' ').split(/\s*=\s*/)
          tags = args[:tags] | (tags || Array.new)
          if values.length == 1
            matching_flashcards = self.matching_flashcards(values[0].split(/,\s*/), Array.new)
            if matching_flashcards.empty?
              puts "~ There is no definition yet.\n\n".colourise
            else
              puts "~ Flashcard #{matching_flashcards.join_with_and(&:to_s)} already exists.\n\n".colourise
            end
          elsif values.length == 2
            matching_flashcards = self.matching_flashcards(values[0].split(/,\s*/), values[1].split(/,\s*/))
            if matching_flashcards.empty?
              puts "~ Adding <green>#{values.inspect}</green>#{" with tags #{tags.join_with_and { |tag| "<yellow>#{tag}</yellow>" }}" unless tags.empty?}.\n\n".colourise
              self.add([values, tags, '--no-edit'].flatten)
            else
              puts "~ Flashcard #{matching_flashcards.join_with_and(&:to_s)} already exists.\n\n".colourise
            end
          else
            puts "<red>!</red> Invalid input, try again.".colourise
          end
        end
      elsif args[:values].length == 1
        matching_flashcards = self.matching_flashcards(args[:values][0].split(/,\s*/), Array.new)

        if matching_flashcards.empty?
          puts "There is no definition for <yellow>#{args[:values][0]}</yellow> yet.".colourise
        else
          matching_flashcards_text = matching_flashcards.map { |f|
            a = f.expressions.join_with_and  { |word| "<yellow>#{word}</yellow>" }
            b = f.translations.join_with_and { |word| "<green>#{word}</green>" }
            "#{a}: #{b}"
          }.join("\n- ")
          puts "<magenta>Matching flashcards:</magenta>\n- #{matching_flashcards_text}".colourise
        end
      elsif args[:values].length == 2
        flashcards = Flashcards.app.flashcards

        expressions  = args[:values][-2].split(/,\s*/)
        translations = args[:values][-1].split(/,\s*/)

        flashcards.each do |flashcard|
          if (! (flashcard.expressions & expressions).empty?) && (! (flashcard.translations & translations).empty?)
            abort "Same flashcard: #{flashcard}.".colourise
          end
        end

        flashcard = Flashcard.new(
          expressions: expressions,
          translations: translations,
          tags: (args[:tags] || Array.new).map { |tag| tag[1..-1].to_sym },
          examples: [
            Example.new(expression: 'Expression 1.', translation: 'Translation 1.'),
            Example.new(expression: 'Expression 2.', translation: 'Translation 2.', label: '', tags: [''])
          ],
          metadata: {
            last_review_time: Time.now
          }
        )

        if args[:args].include?('--no-edit')
          flashcard.examples.clear
          flashcard.metadata.clear
          flashcard.tags << :new
          flashcards << flashcard
          flashcards.save
        else
        if flashcard = self.edit_flashcard(flashcard)
          flashcards << flashcard
          flashcards.save
        else
          abort "No data found."
        end
        end
      else
        # TODO: Commander::HELP_ITEMS[:add]
        abort "Usage: #{File.basename($0)} [lang] [word] [translation] [tags]"
      end
    end

    def self.matching_flashcards(expressions, translations)
      flashcards = Flashcards.app.flashcards # !

      flashcards.select do |flashcard|
        ! (flashcard.expressions & expressions).empty? &&
        (! (flashcard.translations & translations).empty? || translations.empty?)
      end
    end

    def self.edit_flashcard(flashcard)
      path = "/tmp/#{flashcard.expressions.first.tr(' ', '_')}.yml"

      if File.exist?(path) # Give a chance to edit incorrect data.
        # TODO: Compare if anything changed.
        File.open(path, 'a') do |file|
          file.rewind
          file.puts("# NOTE: This file has been created at #{File.mtime(file)}.")
          file.puts("# The data here may not be up to date with the current version.")
        end
      else
        File.open(path, 'w') do |file|
          file.puts(
            "# Verb checklist:",
            "# - Is it tagged as verb?",
            "# - Does it have reflexive form?",
            "# - Is it irregular?")
          file.puts(flashcard.expanded_data.to_yaml)
        end
      end

      system("vim #{path}")

      flashcard_data = YAML.load_file(path)

      if flashcard_data.nil?
        File.unlink(path) && return
      end

      flashcard = Flashcard.new(flashcard_data)

      File.unlink(path)

      flashcard
    end

    def self.review(argv)
      args = self.get_args(argv)
      flashcards = Flashcards.app.flashcards
      flashcards.each do |flashcard|
        if (args[0] && flashcard.expressions.include?(args[0])) || args.empty?
          original_last_review_time = flashcard.metadata[:last_review_time]
          flashcard.metadata[:last_review_time] = Time.now # Do it here, so we have chance to remove it in the YAML.
          if new_flashcard = self.edit_flashcard(flashcard)
            flashcards.replace(flashcard, new_flashcard)
            flashcards.save
          else
            flashcard.metadata[:last_review_time] = original_last_review_time
          end
        end
      end
    end

    def self.reset(argv)
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

    def self.inspect(argv)
      args = self.get_args(argv)
      if args.empty?
        abort "Args cannot be empty."
      end

      puts "~ Using language <yellow>#{Flashcards.app.language.name}</yellow>.".colourise
      flashcards = Flashcards.app.flashcards
      flashcards.each do |flashcard|
        if expression = args.find { |arg| flashcard.expressions.include?(arg.split('.').first) }
          object = expression.split('.')[1..-1].reduce(flashcard) do |object, method|
            object.send(method)
          end
          if object.is_a?(Numeric) || object.is_a?(Symbol) || [true, false, nil].include?(object)
            puts "<green>#{expression}</green>: <blue.bold>#{object.inspect}</blue.bold>".colourise
          else
            puts "\n<green>#{expression}</green>:".colourise(bold: true)
            puts object.to_yaml
          end
        end
      end
    end

    def self.console(argv)
      self.set_language(argv[0]) if argv[0]
      puts "~ Using language <yellow>#{Flashcards.app.language.name}</yellow>.".colourise

      fs = Flashcards.app.flashcards
      ts = Flashcards.app.tests
      require 'pry'; binding.pry
    end

    # TODO: Take in consideration conjugations.
    # TODO: Test class.
    def self.stats(argv)
      languages = argv.empty? ? Flashcards.defined_languages : argv
      languages.each do |language_name|
        Flashcards.app(language_name)
        flashcards = Flashcards.app.flashcards

        body = <<-EOF
<bold>Total flashcards</bold>: <green>#{flashcards.items.length}</green>.
<bold>You remember</bold>: <green>#{flashcards.count { |flashcard| flashcard.correct_answers[:default].length > 2 }}</green> (ones that you answered correctly 3 times or more).

<bold>Ready for review</bold>: <blue>#{flashcards.count(&:time_to_review?)}</blue>.
<bold>To be reviewed later</bold>: <blue>#{flashcards.count { |flashcard| ! flashcard.should_run? }}</blue>.
<bold>Comletely new</bold>: <blue>#{flashcards.count(&:new?)}</blue>.
        EOF

        puts <<-EOF.colourise(bold: true)

<red>Stats for #{language_name.to_s.upcase}</red>

#{flashcards.items.length == 0 ? '<bold>Empty.</bold>' : body}
        EOF
      end
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
          unknown_attributes_text = flashcard.unknown_attributes.join_with_and { |attribute| "<yellow>#{attribute}</yellow>" }
          warn "~ <yellow>#{flashcard.expressions.first}</yellow> has these unknown attributes: #{unknown_attributes_text}.".colourise
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
