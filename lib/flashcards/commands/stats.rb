require 'flashcards/command'

# TODO: Take in consideration conjugations.
# TODO: Test class.

module Flashcards
  class StatsCommand < SingleLanguageCommand
    self.help = <<-EOF
      flashcards <blue.bold>stats</blue.bold>
    EOF

    def run
      languages = argv.empty? ? Flashcards.defined_languages : argv
      languages.each do |language_name|
        Flashcards.app(language_name)
        flashcards = Flashcards.app.flashcards

        body = <<-EOF
<bold>Total flashcards</bold>: <green>#{flashcards.items.length}</green>.
<bold>You remember</bold>: <green>#{flashcards.count { |flashcard| flashcard.correct_answers[:default].length > 2 }}</green> (ones that you answered correctly 3 times or more).

<bold>Ready for review</bold>: <blue>#{flashcards.count(&:time_to_review?)}</blue>.
<bold>To be reviewed later</bold>: <blue>#{flashcards.count { |flashcard| ! flashcard.with(app).should_run? }}</blue>.
<bold>Comletely new</bold>: <blue>#{flashcards.count(&:new?)}</blue>.
        EOF

        puts <<-EOF.colourise(bold: true)

<red>Stats for #{language_name.to_s.upcase}</red>

#{flashcards.items.length == 0 ? '<bold>Empty.</bold>' : body}
        EOF
      end
    end
  end
end
