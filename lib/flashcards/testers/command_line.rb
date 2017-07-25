require 'flashcards/tester'
require 'flashcards/core_exts'

module Flashcards
  class CommnandLineTester < Tester
    using CoreExts
    using RR::ColourExts
    using RR::StringExts

    def run
      flashcards = self.flashcards_to_be_tested_on

#       if flashcards.empty?
#         abort(<<-EOF.colourise(bold: true))
# <red>There are currently no flashcards that are new or pending to review.</red>
#   Add new ones by running <bright_black>$ #{File.basename($0)} add expression translation</bright_black>.
#   You can also reset all your learning by running <bright_black>$ #{File.basename($0)} reset</bright_black> or just wait until tomorrow.
#         EOF
#       end

      if Flashcards.app.language.accents_help
        puts Flashcards.app.language.accents_help.colourise
      end

      flashcards.shuffle.each do |flashcard|
        self.test_flashcard(flashcard)
      end

      self.show_stats unless (@correct + @incorrect) == 0

      self.run_tests
    end

    def run_tests
      all_tests = Flashcards::Test.load(Flashcards.app.language.name)
      selected_tests = self.select_flashcards_to_be_tested_on(all_tests, 3)

      (puts; puts) unless selected_tests.empty?

      selected_tests.map! do |test|
        opts = test.options.map.with_index { |item, index| "#{item} <magenta>#{index + 1}</magenta>" }.join(' ').colourise
        print "#{test.prompt}#{" (#{opts})" unless test.options.empty?}: "
        if test.mark($stdin.readline.chomp)
          puts "<green>✔︎</green>\n\n".colourise(bold: true)
        else
          puts "<red>✘</red> It is #{test.answer}.\n\n".colourise(bold: true)
        end
      end

      Flashcards::Test.save(Flashcards.app.language.name.to_s, all_tests.map(&:data))
    end

    def test_flashcard(flashcard)
      if flashcard.correct_answers[:default].length >= 1
        # Switch sides.
        if example = flashcard.examples.sample
          puts('', flashcard.word_variants.reduce(example.expression) do |result, expression|
            result.
              sub(/\b#{expression}\b/i, '_____')
          end.colourise)
        else
          puts
        end

        synonyms = @all_flashcards.select { |f2| ! (flashcard.translations & f2.translations).empty? } - [flashcard]
        if synonyms.empty?
          print "#{flashcard.translations.map { |t| "<underline>#{t}</underline>" }.join_with_and('or')}#{" (#{flashcard.hint})" if flashcard.hint}: ".colourise(bold: true)
        else
          print "#{flashcard.translations.map { |t| "<underline>#{t}</underline>" }.join_with_and('or')}#{" (#{flashcard.hint})" if flashcard.hint} (also can be #{synonyms.map(&:expressions).flatten.map { |e| "<underline>#{e}</underline>" }.join(', ')}): ".colourise(bold: true)
        end
      else
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
      end

      if flashcard.mark(translation = $stdin.readline.chomp)
        # This is for silents and (maybe, but not sure) when the sides are switched?
        Flashcards.app.language.say_aloud(flashcard.expressions.include?(translation) ? translation : flashcard.expressions.first)

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
        @incorrect += 1
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
        @indentation = 2
        if example.label && example.tags.empty?
          puts "   <green>#{example.label}</green>:".colourise
        elsif example.label && ! example.tags.empty?
          puts "   <green>#{example.label}</green> (<yellow>#{example.tags.join(' ')}</yellow>):".colourise
        elsif ! example.label && ! example.tags.empty?
          puts "   <yellow>#{example.tags.join(' ')}</yellow>:".colourise
        else
          @indentation = 0
        end
        puts "   #{' ' * @indentation}<cyan>#{example.expression}</cyan>".colourise
        puts "   #{' ' * @indentation}<magenta>#{example.translation}</magenta>\n".colourise
        puts unless flashcard.examples.last == example
      end
    end

    def show_stats
      puts "\n<green>Statistics</green>".colourise(bold: true)
      blob = "- <bold>Total:</bold> #{@correct + @incorrect} (" +
        [("<green>#{@correct} correct</green>" unless @correct == 0),
          ("<red>#{@incorrect} incorrect</red>" unless @incorrect == 0)].compact.join(' and ') + ').'
      puts blob.colourise
      # puts "- Review"
      # puts "- New vocabulary:"
    end

    def run_conjugation_tests(flashcard)
      if flashcard.tags.include?(:verb)
        # FIXME: flashcard.expressions.sample doesn't make sense in this case.
        verb = @language.load_verb(flashcard.expressions.sample)
        puts # TODO: unless there are no configured/enabled ones.

        conjugation_groups_to_run = @language.conjugation_groups.select do |conjugation_group_name|
          flashcard.should_run?(conjugation_group_name)
        end

        conjugation_groups_to_run = conjugation_groups_to_run.shuffle.sample(3)

        conjugation_groups_to_run.each do |conjugation_group_name|
          conjugation_group = verb.send(conjugation_group_name)
          self.run_conjugation_test_for(conjugation_group, flashcard, verb)
        end
      else
        @correct += 1
      end
    # rescue StandardError => e # No signals such as Interrupt.
    #   require 'pry'; binding.pry ###
    end

    def run_conjugation_test_for(conjugation_group, flashcard, verb)
      person = conjugation_group.forms.keys.sample
      if person == :default
        print <<-EOF.colourise(bold: true).chomp + ' '
~ <magenta>#{conjugation_group.tense.to_s.titlecase} <cyan>is:</cyan></magenta>
        EOF
      else
        print <<-EOF.colourise(bold: true).chomp + ' '
~ <magenta>#{person.to_s.titlecase} <cyan>form of the</cyan> #{conjugation_group.tense}<cyan> tense is:</cyan></magenta>
        EOF
      end

      answer = $stdin.readline.chomp
      answers = [conjugation_group.send(person)].flatten
      x = if answers.include?(answer)
        puts "    <green>✔︎  Correct.</green>".colourise
        Flashcards.app.language.say_aloud(answer)
        flashcard.mark_as_correct(conjugation_group.tense)
        @correct += 1
      else
        puts "  <red>  ✘  The correct form is #{[conjugation_group.send(person)].flatten.join_with_and('or')}</red>.".colourise
        puts "  <red>     This is an exception.</red>".colourise if conjugation_group.irregular?(person)
        flashcard.mark_as_failed(conjugation_group.tense)
        @incorrect += 1
      end

      # TODO: Format the lengts so | is always where it's supposed to be (delete tags before calculation).
      unless conjugation_group.pretty_inspect.empty? # Gerundio, participio.
        puts "\n    All the forms of the #{conjugation_group.tense} are:"
        puts conjugation_group.show_forms.map { |line| "    #{line}"  }
      end
      puts

      x
    end
  end
end
