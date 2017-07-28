require 'flashcards/command'
require 'flashcards/utils'

module Flashcards
  class ReviewCommand < SingleLanguageCommand
    self.help = <<-EOF
      flashcards <yellow>review</yellow><bright_black> # Review all the flashcards.
      flashcards <yellow>review</yellow> todavía<bright_black> # Review given flashcard.
      <magenta.bold>EDITOR=vim</magenta.bold> flashcards <green>review</green> <bright_black># Edit your flashcards in $EDITOR.</bright_black>
    EOF

    def run
      args = self.get_args(@args)
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
  end
end
