require 'yaml'
require 'flashcards/flashcard'
require 'flashcards/core_exts'
require 'flashcards/verb'

begin
  path = File.expand_path(ENV['FF'] || '~/.config/flashcards.yml')
  FLASHCARDS_DATA = File.new(path)
rescue Errno::ENOENT
  File.open(path, 'w') { }
  retry
end

module Flashcards
  def self.load_flashcards(flashcard_data)
    flashcard_data.map do |flashcard_data|
      begin
        Flashcard.new(flashcard_data)
      rescue => error
        abort "Loading flashcard #{flashcard_data.inspect} failed: #{error.message}.\n\n#{error.backtrace}"
      end
    end
  end

  def self._load(&block)
    data = YAML.load(FLASHCARDS_DATA.read) || Array.new

    flashcards = load_flashcards(data)
    block.call(flashcards)
  end

  def self.load_do_then_save(&block)
    data = YAML.load(FLASHCARDS_DATA.read) || Array.new

    flashcards = load_flashcards(data)
    data = block.call(flashcards)

    FLASHCARDS_DATA.close
    yaml = data.to_yaml
    File.open(FLASHCARDS_DATA.path, 'w') { |file| file << yaml }
  end

  $correct = 0; $incorrect = 0
  def self.run(all_flashcards)
    flashcards_to_review = all_flashcards.select { |flashcard| flashcard.time_to_review? }
    new_flashcards = all_flashcards.select { |flashcard| flashcard.new? }

    limit = ENV['LIMIT'] ? ENV['LIMIT'].to_i : 25 # TODO: Change name so it can't conflict and document it.
    abort 'LIMIT=0 for obtaining everything is not yet supported.' if limit == 0

    # p [:limit, limit] ####
    # p [:to_review________, flashcards_to_review.map(&:translations)]
    # p [:to_review_limited, flashcards_to_review.shuffle[0..(limit - 1)].map(&:translations)]
    # puts ####
    # p [:new_flashcards________, new_flashcards.map(&:translations)]
    # p [:new_flashcards_limited, new_flashcards.shuffle[0..(limit - flashcards_to_review.length - 1)].map(&:translations), new_flashcards.shuffle[0..(limit - flashcards_to_review.length - 1)].length]

    if (limit - flashcards_to_review.length) < 0 # Otherwise we run into a problem with [0..0] still returning the first item instead of nothing.
      # p [:x] ####
      flashcards = flashcards_to_review.shuffle[0..(limit - 1)]
    else
      flashcards_to_review_limited = flashcards_to_review.shuffle[0..(limit - 1)]
      index = limit - flashcards_to_review_limited.length - 1
      # p [:i, index] ####
      if index < 0
        flashcards = flashcards_to_review_limited
      else
        new_flashcards_limited = new_flashcards.shuffle[0..(index)]
        flashcards = flashcards_to_review_limited + new_flashcards_limited
      end
    end


    # puts ####
    # p [:flashcards, flashcards.map(&:translations)] ####

    if flashcards.empty?
      abort colourise(<<-EOF, bold: true)
<red>There are currently no flashcards that are new or pending to review.</red>
    Add new ones by running <bright_black>$ #{File.basename($0)} add expression translation</bright_black>.
    You can also reset all your learning by running <bright_black>$ #{File.basename($0)} reset</bright_black> or just wait until tomorrow.
        EOF
    end

    # TODO: First test ones that has been tested before and needs refreshing before
    # they go to the long-term memory. Then test the new ones and finally the remembered ones.
    # Limit count of each.
    flashcards.shuffle.each do |flashcard|
      if example = flashcard.examples.sample
        puts('', colourise(flashcard.expressions.reduce(example.expression) do |result, expression|
          result.
            sub(/\b#{expression}\b/, expression.bold).
            sub(/\b#{expression.titlecase}\b/, expression.titlecase.bold)
        end))
      else
        puts
      end

      synonyms = all_flashcards.select { |f2| ! (flashcard.translations & f2.translations).empty? } - [flashcard]
      if synonyms.empty?
        print colourise("#{flashcard.expressions.join_with_and('or')}#{" (#{flashcard.hint})" if flashcard.hint}: ", bold: true)
      else
        print colourise("#{flashcard.expressions.join_with_and('or')}#{" (#{flashcard.hint})" if flashcard.hint} (also can be #{synonyms.map(&:expressions).join(', ')}): ", bold: true)
      end

      if flashcard.mark(translation = $stdin.readline.chomp)
        if flashcard.translations.length == 1
          synonyms = [] # This is so if we have one main translation and one silent one, we don't show it as a synonym.
          # In case there actually are more (non-silent) synonyms, we will just show them all.
        else
          synonyms = flashcard.translations - [translation]
        end
        if flashcard.translations.include?(translation)
          translation_or_first_translation = translation
        else
          translation_or_first_translation = flashcard.translations[0] # For silent translations.
        end

        flashcard_expressions = flashcard.expressions.map.with_index { |word, index| "<yellow>#{index == 0 ? word.titlecase : word}</yellow>" }.join_with_and('or')
        list_of_synonyms = (synonyms - [translation]).map { |word| "<yellow>#{word}</yellow>" }.join_with_and('or')

        puts colourise(<<-EOF, bold: true)
  <green>✔︎  <yellow>#{flashcard_expressions}</yellow> is indeed <yellow>#{translation_or_first_translation}</yellow>.
  #{"It can also mean #{list_of_synonyms}." if synonyms.any?}</green>
  EOF

        # Experimental.
        if flashcard.tags.include?(:verb)
          verb = Verb.new(flashcard.expressions.sample)
          all = verb.tenses.all? do |tense|
            person = tense.forms.keys.sample
            print colourise(<<-EOF, bold: true).chomp + ' '
  ~ <magenta>#{person.to_s.titlecase} <cyan>form of the</cyan> #{tense.tense}<cyan> tense is:</cyan></magenta>
            EOF
            answer = $stdin.readline.chomp
            x = if answer == tense.send(person)
              puts colourise("  <green>✔︎  </green>")
              true
            else
              puts colourise("  <red>✘  The correct form is #{tense.send(person)}</red>.")
              puts colourise("  <red>   This is an exception.</red>") if tense.exception?(person)
              flashcard.mark_as_failed
            end

            _wrap = Proc.new do |tense, person|
              if tense.exception?(person)
                "<red>#{person} #{tense.send(person)}</red>"
              else
                "<green>#{person} #{tense.send(person)}</green>"
              end
            end

            # TODO: Format the lengts so | is always where it's supposed to be (delete tags before calculation).
            puts colourise(<<-EOF)

    All the forms of the #{tense.tense} are:
      #{_wrap.call(tense, :yo)} | #{_wrap.call(tense, :nosotros)}
      #{_wrap.call(tense, :tú)} | #{_wrap.call(tense, :vosotros)}
      #{_wrap.call(tense, :él)} | #{_wrap.call(tense, :ellos)}\n
            EOF

            x
          end

          all ? $correct += 1 : $incorrect += 1
        else
          $correct += 1
        end
      else
        $incorrect += 1
        list = flashcard.translations.map do |word|
          word
          "<yellow>#{word}</yellow>"
        end.join_with_and('<red>or</red>')

        puts colourise("  <red>✘  #{flashcard.expressions.join_with_and('or').titlecase} is </red>#{list}.\n", bold: true)
      end

      if flashcard.note
        puts colourise(<<-EOF, bold: true)
  \n  <blue>ℹ #{flashcard.note}</blue>
        EOF
      end

      # puts unless flashcard.examples.empty?
      flashcard.examples.each do |example|
        puts colourise("     <cyan>#{example.expression}</cyan>")
        puts colourise("     <magenta>#{example.translation}</magenta>\n\n")
      end
    end

    puts colourise("\n<green>Statistics</green>", bold: true)
    puts colourise("- <bold>Total:</bold> #{$correct + $incorrect} (" +
      [("<green>#{$correct} correct</green>" unless $correct == 0),
        ("<red>#{$incorrect} incorrect</red>" unless $incorrect == 0)].compact.join(' and ') + ').')
    # puts "- Review"
    # puts "- New vocabulary:"
  rescue Interrupt
    # TODO: Save current progress (metadata).
    puts; exit
  end
end
