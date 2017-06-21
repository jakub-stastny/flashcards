module Flashcards
  class Tester
    def initialize(all_flashcards, language, config)
      @all_flashcards = all_flashcards
      @language, @config = language, config
      @correct, @incorrect = 0, 0
    end

    def run
      raise NotImplementedError.new('Override this in a subclass.')
    end

    # TODO: First test ones that has been tested before and needs refreshing before
    # they go to the long-term memory. Then test the new ones and finally the remembered ones.
    # Limit count of each.
    def select_flashcards_to_be_tested_on
      flashcards_to_review = @all_flashcards.select { |flashcard| flashcard.time_to_review? }
      new_flashcards = @all_flashcards.select { |flashcard| flashcard.new? }

      if limit = @config.limit_per_run
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
      else
        (new_flashcards + flashcards_to_review).shuffle
      end
    end
  end
end
