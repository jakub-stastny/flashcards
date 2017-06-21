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

      flashcard = Flashcard.new(
        expression: args[-2].split(','),
        translations: args[-1].split(','),
        tags: tags.map { |tag| tag[1..-1].to_sym },
        examples: [
          Example.new('Expression.', 'Translation.'),
          Example.new('Expression.', 'Translation.')
        ]
      )

      self.add_flashcard((args.length == 3) ? args[0] : nil, flashcard)
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

    def self.edit(argv)
      editor = ENV['EDITOR'] || 'vim'
      exec "#{editor} #{Flashcards.app(argv.first).flashcard_file}"
    end

    def self.stats
      Flashcards.app._load do |flashcards|
        x= flashcards.select { |flashcard| flashcard.tags.include?(:irregular) }

        puts <<-EOF.colourise(bold: true)
<red>Stats:</red>
  Total flashcards: #{flashcards.length}.
  You remember: #{flashcards.count { |flashcard| flashcard.correct_answers.length > 2 }} (ones that you answered correctly 3 times or more).
  To be reviewed: #{flashcards.count(&:time_to_review?)}.
  Comletely new: #{flashcards.count(&:new?)}.
  Unsupported irregular verbs: XXXXXXXXX
        EOF
      end
    end

    # Alternatives:
    # https://github.com/ghidinelli/fred-jehle-spanish-verbs (database)
    def self.verify
      require 'conjugate'

      Flashcards.app._load do |flashcards|
        {present: :presente, past: :pretérito, future: :futuro}.each do |tense_en_name, tense_es_name|
          flashcards.each do |flashcard|
            if flashcard.tags.include?(:verb)
              verb = flashcard.verb
              [:yo, :tú, :él, :nosotros, :vosotros, :ellos].each do |pronoun|
                begin
                  asciified_pronoun = pronoun.to_s.tr('éú', 'eu')
                  v1 = Conjugate::Spanish.conjugate(pronoun: asciified_pronoun, verb: verb.infinitive, tense: tense_en_name)
                  v2 = verb.send(tense_es_name).send(pronoun)
                  warn "#{v1} != #{v2}" if v1 != v2
                  v1 == v2
                rescue Exception => error
                  warn "~ Error #{error.class}: #{error.message}. Leaving out #{verb.infinitive} in #{pronoun} form of #{tense_en_name} tense."
                  true
                end
              end
            end
          end
        end
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
      puts "<blue>~</blue> <green>Writing accents:</green> <red>á</red> ⌥-e a   <blue>ñ</blue> ⌥-n n   <yellow>ü</yellow> ⌥-u u   <magenta>¡</magenta> ⌥-1   <magenta>¿</magenta> ⌥-⇧-?".colourise(bold: true)
      Flashcards.app.load_do_then_save do |flashcards|
        Flashcards.app.run(flashcards)

        # Save the metadata.
        flashcards.map(&:data)
      end
    end
  end
end
