require 'flashcards/tester'
require 'flashcards/core_exts'

module Flashcards
  class CommnandLineTester < Tester
    using CoreExts
    using RR::ColourExts
    using RR::StringExts

    $correct = 0; $incorrect = 0
    def run
      flashcards_to_review = @all_flashcards.select { |flashcard| flashcard.time_to_review? }
      new_flashcards = @all_flashcards.select { |flashcard| flashcard.new? }

      flashcards = select_flashcards(new_flashcards, flashcards_to_review)

      if flashcards.empty?
        abort(<<-EOF.colourise(bold: true))
  <red>There are currently no flashcards that are new or pending to review.</red>
      Add new ones by running <bright_black>$ #{File.basename($0)} add expression translation</bright_black>.
      You can also reset all your learning by running <bright_black>$ #{File.basename($0)} reset</bright_black> or just wait until tomorrow.
          EOF
      end

      # TODO: First test ones that has been tested before and needs refreshing before
      # they go to the long-term memory. Then test the new ones and finally the remembered ones.
      # Limit count of each.
      flashcards.shuffle.each do |flashcard|
        self.run_one(flashcard)
      end

      puts "\n<green>Statistics</green>".colourise(bold: true)
      blob = "- <bold>Total:</bold> #{$correct + $incorrect} (" +
        [("<green>#{$correct} correct</green>" unless $correct == 0),
          ("<red>#{$incorrect} incorrect</red>" unless $incorrect == 0)].compact.join(' and ') + ').'
      puts blob.colourise
      # puts "- Review"
      # puts "- New vocabulary:"
    rescue Interrupt
      # TODO: Save current progress (metadata).
      puts; exit
    end

    def run_one(flashcard)
      if example = flashcard.examples.sample
        puts('', flashcard.expressions.reduce(example.expression) do |result, expression|
          result.
            sub(/\b#{expression}\b/, "<bold>#{expression}</bold>").
            sub(/\b#{expression.titlecase}\b/, "<bold>#{expression.titlecase}</bold>")
        end.colourise)
      else
        puts
      end

      synonyms = @all_flashcards.select { |f2| ! (flashcard.translations & f2.translations).empty? } - [flashcard]
      if synonyms.empty?
        print "#{flashcard.expressions.join_with_and('or')}#{" (#{flashcard.hint})" if flashcard.hint}: ".colourise(bold: true)
      else
        print "#{flashcard.expressions.join_with_and('or')}#{" (#{flashcard.hint})" if flashcard.hint} (also can be #{synonyms.map(&:expressions).join(', ')}): ".colourise(bold: true)
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

        puts <<-EOF.colourise(bold: true)
<green>✔︎  <yellow>#{flashcard_expressions}</yellow> is indeed <yellow>#{translation_or_first_translation}</yellow>.</green>
        EOF

        puts <<-EOF.colourise(bold: true) if synonyms.any?
   #{"It can also mean #{list_of_synonyms}." }
        EOF

        # Experimental.
        self.run_conjugation_tests(flashcard)
      else
        $incorrect += 1
        list = flashcard.translations.map do |word|
          word
          "<yellow>#{word}</yellow>"
        end.join_with_and('<red>or</red>')

        puts "  <red>✘  #{flashcard.expressions.join_with_and('or').titlecase} is </red>#{list}.\n".colourise(bold: true)
      end

      if flashcard.note
        puts <<-EOF.colourise(bold: true)
  \n    <blue>ℹ #{flashcard.note}</blue>
        EOF
      end

      puts unless flashcard.examples.empty?
      flashcard.examples.each do |example|
        puts "     <cyan>#{example.expression}</cyan>".colourise
        puts "     <magenta>#{example.translation}</magenta>\n".colourise
        puts unless flashcard.examples.last == example
      end
    end

    def run_conjugation_tests(flashcard)
      if flashcard.tags.include?(:verb)
        # FIXME: flashcard.expressions.sample doesn't make sense in this case.
        verb = self.language.verb(flashcard.expressions.sample, flashcard.conjugations)
        puts
        Flashcards.app.language.conjugation_groups.each do |conjugation_group_name|
          conjugation_group = verb.send(conjugation_group_name)
          person = conjugation_group.forms.keys.sample # FIXME: vos is not present in this.
          print <<-EOF.colourise(bold: true).chomp + ' '
~ <magenta>#{person.to_s.titlecase} <cyan>form of the</cyan> #{conjugation_group.tense}<cyan> tense is:</cyan></magenta>
          EOF
          answer = $stdin.readline.chomp
          x = if answer == conjugation_group.send(person)
            puts "    <green>✔︎  </green>".colourise
            flashcard.mark_as_correct(conjugation_group_name)
            $correct += 1
          else
            puts "  <red>  ✘  The correct form is #{conjugation_group.send(person)}</red>.".colourise
            puts "  <red>     This is an exception.</red>".colourise if conjugation_group.exception?(person)
            flashcard.mark_as_failed(conjugation_group_name)
            $incorrect += 1
          end

          _wrap = Proc.new do |tense, person|
            if conjugation_group.exception?(person)
              "<red>#{person} #{conjugation_group.send(person)}</red>"
            else
              "<green>#{person} #{conjugation_group.send(person)}</green>"
            end
          end

          # TODO: Format the lengts so | is always where it's supposed to be (delete tags before calculation).
          puts <<-EOF.colourise

  All the forms of the #{conjugation_group.tense} are:
    #{_wrap.call(conjugation_group, :yo)} | #{_wrap.call(conjugation_group, :nosotros)}
    #{_wrap.call(conjugation_group, :tú)} | #{_wrap.call(conjugation_group, :vosotros)}
    #{_wrap.call(conjugation_group, :él)} | #{_wrap.call(conjugation_group, :ellos)}\n
          EOF

          x
        end
      else
        $correct += 1
      end
    end
  end
end
