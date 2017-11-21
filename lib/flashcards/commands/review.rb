require 'flashcards/command'
require 'flashcards/utils'

module Flashcards
  class ReviewCommand < SingleLanguageCommand
    using RR::ColourExts

    self.help = <<-EOF.gsub(/^\s*/, '')
      flashcards <yellow>review</yellow><bright_black> # Review all the flashcards.
      flashcards <yellow>review</yellow> todavía<bright_black> # Review given flashcard.
      <magenta.bold>EDITOR=vim</magenta.bold> flashcards <green>review</green> <bright_black># Edit your flashcards in $EDITOR.</bright_black>
      <magenta.bold>LIMIT=5</magenta.bold> flashcards <green>review</green> <bright_black># Edit 5 flashcards.</bright_black>
    EOF

    def edit_all(flashcards)
      limit = ENV.fetch('LIMIT') { '3' }.to_i
      new_flashcards = flashcards.select { |flashcard| flashcard.tags.include?(:new) }
      not_new_flashcards = flashcards.reject { |flashcard| flashcard.tags.include?(:new) }
      sorted_not_new_flashcards = not_new_flashcards.sort_by do |flashcard|
        flashcard.metadata[:last_review_time] || Time.now - 60 * 60 * 24 * 365
      end

      dataset = new_flashcards.shuffle + sorted_not_new_flashcards
      dataset[0..(limit - 1)].each.with_index do |flashcard, index|
        unless index == 0
          print "~ Editing flashcard <blue.bold>#{index + 1}</blue.bold> of <blue.bold>#{dataset.length < limit ? dataset.length : limit}</blue.bold>. Press <green>Enter</green> to continue. ".colourise
          begin
            STDIN.readline
          rescue Interrupt
            puts; exit
          end
        end

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
