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

def load_flashcards(flashcard_data)
  flashcard_data.map do |flashcard_data|
    begin
      Flashcard.new(flashcard_data)
    rescue => error
      abort "Loading flashcard #{flashcard_data.inspect} failed: #{error.message}"
    end
  end
end

def _load(&block)
  data = YAML.load(FLASHCARDS_DATA.read) || Array.new

  flashcards = load_flashcards(data)
  block.call(flashcards)
end

def load_do_then_save(&block)
  data = YAML.load(FLASHCARDS_DATA.read) || Array.new

  flashcards = load_flashcards(data)
  data = block.call(flashcards)

  FLASHCARDS_DATA.close
  yaml = data.to_yaml
  File.open(FLASHCARDS_DATA.path, 'w') { |file| file << yaml }
end

$correct = 0; $incorrect = 0
def run(flashcards)
  flashcards_to_review = flashcards.select { |flashcard| flashcard.time_to_review? }
  new_flashcards = flashcards.select { |flashcard| flashcard.new? }

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
    abort colourise("<red>There are currently no flashcards that are new or pending to review.</red>\n" +
      "  Add new ones by running <bright_black>$ #{File.basename($0)} add expression translation</bright_black>.\n" +
      "  You can also reset all your learning by running <bright_black>$ #{File.basename($0)} reset</bright_black> or just wait until tomorrow.",
      bold: true)
  end

  # TODO: First test ones that has been tested before and needs refreshing before
  # they go to the long-term memory. Then test the new ones and finally the remembered ones.
  # Limit count of each.
  flashcards.shuffle.each do |flashcard|
    if sample = flashcard.examples.sample
      puts '', colourise(sample[0].
        sub(flashcard.expression, flashcard.expression.bold).
        sub(flashcard.expression.titlecase, flashcard.expression.titlecase.bold))
    else
      puts
    end

    if synonyms = flashcards.select { |f2| flashcard.expression == f2.expression }
      print "#{flashcard.expression}#{" (#{flashcard.hint})" if flashcard.hint}: ".bold
    else
      print "#{flashcard.expression}#{" (#{flashcard.hint})" if flashcard.hint} (not any of these: #{synonyms.map(&:expression).join(', ')}): ".bold
    end

    if flashcard.mark(translation = $stdin.readline.chomp)
      if flashcard.translations.length == 1
        synonyms = [] # This is so if we have one main translation and one silent one, we don't show it as a synonym.
        # In case there actually are more (non-silent) synonyms, we will just show them all.
      else
        synonyms = flashcard.translations - [translation]
      end
      puts colourise("  <green>✔︎  </green>" +
        "<yellow>#{flashcard.expression.titlecase}</yellow> " +
        "<green>is indeed <yellow>#{translation}</yellow>. </green>" +
        (synonyms.any? ? "<green>It can also mean</green> #{synonyms.map { |word| "<yellow>#{word}</yellow>" }.join_with_and('or')}<green>.</green>" : '') +
        "\n", bold: true)

      # Experimental.
      if flashcard.tags.include?(:verb) && ! flashcard.tags.include?(:irregular)
        verb = Verb.new(flashcard.expression)
        all = verb.tenses.all? do |tense|
          person = tense.forms.sample
          print colourise("\n  ~ <magenta>#{person.to_s.titlecase}</magenta> <cyan>form of the</cyan> <magenta>#{tense.tense}</magenta><cyan> tense is:</cyan> ", bold: true)
          answer = $stdin.readline.chomp
          if answer == tense.send(person)
            puts colourise("  <green>✔︎  </green>")
            true
          else
            puts colourise("  <red>✘  The correct form is #{tense.send(person)}</red>")
            flashcard.mark_as_failed
          end
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

      puts colourise("  <red>✘  #{flashcard.expression.titlecase} is </red>#{list}.\n", bold: true)
    end

    if flashcard.note
      puts colourise(<<-EOF, bold: true)
\n  <blue>ℹ #{flashcard.note}</blue>
      EOF
    end

    puts unless flashcard.examples.empty?
    flashcard.examples.each do |expression, translation|
      puts colourise("     <cyan>#{expression}</cyan>")
      puts colourise("     <magenta>#{translation}</magenta>\n\n")
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
