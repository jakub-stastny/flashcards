require 'flashcards/core_exts'

module Flashcards
  class Tester
    using CoreExts
    using RR::StringExts
    using RR::ColourExts

    def initialize(all_flashcards, language, config)
      @all_flashcards = all_flashcards
      @language, @config = language, config
      @correct, @incorrect = 0, 0
    end

    def run
      raise NotImplementedError.new('Override this in a subclass.')
    end

    def filter_out_unverified_verbs(all_flashcards)
      return all_flashcards if ENV['FLASHCARDS']

      without_unverified_verbs = all_flashcards.reject { |flashcard| flashcard.tags.include?(:verb) && ! flashcard.tags.include?(:verified) }

      unless without_unverified_verbs == all_flashcards
        unverified_verbs = all_flashcards - without_unverified_verbs
        warn "<blue.bold>~</blue.bold> <yellow.bold>You have unverified verbs:</yellow.bold> #{unverified_verbs.map { |flashcard| flashcard.expressions.first}.join_with_and }.".colourise
        warn "  You will not be tested on these. Run <underline>flashcards verify</underline> first to check the conjugations against an online dictionary.\n\n".colourise
      end

      without_unverified_verbs
    end

    # TODO: First test ones that has been tested before and needs refreshing before
    # they go to the long-term memory. Then test the new ones and finally the remembered ones.
    # Limit count of each.
    def select_flashcards_to_be_tested_on(all_flashcards, limit_per_run)
      flashcards_to_review = all_flashcards.select { |flashcard| flashcard.time_to_review? }
      new_flashcards = all_flashcards.select { |flashcard| flashcard.new? }

      if limit_per_run
        # p [:limit, limit_per_run] ####
        # p [:to_review________, flashcards_to_review.map(&:translations)]
        # p [:to_review_limited, flashcards_to_review.shuffle[0..(limit - 1)].map(&:translations)]
        # puts ####
        # p [:new_flashcards________, new_flashcards.map(&:translations)]
        # p [:new_flashcards_limited, new_flashcards.shuffle[0..(limit - flashcards_to_review.length - 1)].map(&:translations), new_flashcards.shuffle[0..(limit - flashcards_to_review.length - 1)].length]

        if (limit_per_run - flashcards_to_review.length) < 0 # Otherwise we run into a problem with [0..0] still returning the first item instead of nothing.
          # p [:x] ####
          flashcards = flashcards_to_review.shuffle[0..(limit_per_run - 1)]
        else
          flashcards_to_review_limited = flashcards_to_review.shuffle[0..(limit_per_run - 1)]
          index = limit_per_run - flashcards_to_review_limited.length - 1
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
