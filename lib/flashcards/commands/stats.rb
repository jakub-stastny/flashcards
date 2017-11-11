require 'flashcards/command'
require 'refined-refinements/colours'

# TODO: Take in consideration conjugations.
# TODO: Test class.

module Flashcards
  class StatsCommand < SingleLanguageCommand
    using RR::ColourExts

    self.help = <<-EOF.gsub(/^\s*/, '')
      flashcards <blue.bold>stats</blue.bold>
    EOF

    def run
      languages = @args.empty? ? Flashcards.defined_languages : @args
      languages.each do |language_name|
        app = Flashcards::App.new(language_name)
        begin
          flashcards = app.flashcards
        rescue
          puts "Flashcards for language <bold>#{language_name.upcase}</bold> are not in a correct format.".colourise
          next
        end

        body = <<-EOF
<bold>Total flashcards</bold>: <green>#{flashcards.items.length}</green>.
<bold>You remember</bold>: <green>#{flashcards.count { |flashcard| flashcard.correct_answers[:default].length > 2 }}</green> (ones that you answered correctly 3 times or more).

<bold>Ready for review</bold>: <blue>#{flashcards.map { |f| f.with(app) }.count(&:time_to_review?)}</blue>.
<bold>To be reviewed later</bold>: <blue>#{flashcards.count { |flashcard| ! flashcard.with(app).should_run? }}</blue>.
<bold>Comletely new</bold>: <blue>#{flashcards.map { |f| f.with(app) }.count(&:new?)}</blue>.
        EOF

        puts <<-EOF.colourise(bold: true)

<red>Stats for #{language_name.to_s.upcase}</red>

#{flashcards.items.length == 0 ? '<bold>Empty.</bold>' : body}
        EOF
      end
    end
  end
end
