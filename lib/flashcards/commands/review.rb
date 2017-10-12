require 'flashcards/command'
require 'flashcards/utils'

module Flashcards
  class ReviewCommand < SingleLanguageCommand
    self.help = <<-EOF
      flashcards <yellow>review</yellow><bright_black> # Review all the flashcards.
      flashcards <yellow>review</yellow> todavía<bright_black> # Review given flashcard.
      <magenta.bold>EDITOR=vim</magenta.bold> flashcards <green>review</green> <bright_black># Edit your flashcards in $EDITOR.</bright_black>
    EOF

    def edit_all(flashcards)
      new_flashcards = flashcards.select { |flashcard| flashcard.tags.include?(:new) }
      not_new_flashcards = flashcards.reject { |flashcard| flashcard.tags.include?(:new) }
      (new_flashcards + not_new_flashcards)[0..10].each do |flashcard|
        self.edit(flashcards, flashcard)
      end
    end

    def edit(flashcards, flashcard)
      original_last_review_time = flashcard.metadata[:last_review_time]
      flashcard.metadata[:last_review_time] = Time.now # Do it here, so we have chance to remove it in the YAML.

      if new_flashcard = Utils.edit_flashcard(flashcard)
        flashcards.replace(flashcard, new_flashcard)
        flashcards.save
      else
        flashcard.metadata[:last_review_time] = original_last_review_time
      end
    end

    def find_by_expression(flashcards, expression)
      flashcards.items.find do |flashcard|
        flashcard.expressions.include?(expression)
      end
    end

    def run
      app, args = self.get_args(@args)

      if args[0]
        flashcard = self.find_by_expression(app.flashcards, args[0])
        abort "No such flashcard found." if flashcard.nil?
        self.edit(app.flashcards, flashcard)
      else
        self.edit_all(app.flashcards)
      end
    end
  end
end
