# frozen_string_literal: true

require 'flashcards/core_exts'

module Flashcards
  class Tester
    using CoreExts
    using RR::StringExts
    using RR::ColourExts

    def initialize(app, all_flashcards, language, config)
      @app = app # TODO: Deprecate all_flashcards, language, config since we have this.
      @all_flashcards = all_flashcards
      @language, @config = language, config
      @correct, @incorrect = 0, 0
    end

    def run
      raise NotImplementedError, 'Override this in a subclass.'
    end

    def filter_out_unverified_verbs(all_flashcards)
      return all_flashcards if ENV['FLASHCARDS']

      all_flashcards.filter_out(:unverified_verbs) do |flashcard|
        flashcard.tags.include?(:verb) && !flashcard.verified?
      end

      unverified_verbs = all_flashcards.filtered_out_items(:unverified_verbs)

      unless unverified_verbs.empty?
        unverified_verbs_text = unverified_verbs.join_with_and { |flashcard| flashcard.expressions.first }
        warn "<blue.bold>~</blue.bold> <yellow.bold>You have unverified verbs:</yellow.bold> #{unverified_verbs_text}.".colourise
        warn "  You will not be tested on these. Run <underline>flashcards verify</underline> first to check the conjugations against an online dictionary.\n\n".colourise
      end
    end

    def filter_out_verbs_with_changed_conjugations(all_flashcards)
      return all_flashcards if ENV['FLASHCARDS']

      all_flashcards.filter_out(:verbs_with_changed_conjugations) do |flashcard|
        flashcard.tags.include?(:verb) && flashcard.verified? && !flashcard.with(@app).verify
      end

      changed_verbs = all_flashcards.filtered_out_items(:verbs_with_changed_conjugations)

      unless changed_verbs.empty?
        changed_verbs_text = changed_verbs.join_with_and { |flashcard| flashcard.expressions.first }
        warn "<blue.bold>~</blue.bold> <yellow.bold>Conjugations of these verbs has changed:</yellow.bold> #{changed_verbs_text}.".colourise
        warn "  They are most likely incorrect. Run <underline>flashcards verify</underline> first to check the conjugations against an online dictionary. In the meantime, you will not be tested on these.\n\n".colourise
      end
    end

    def filter_out_new_flashcards(all_flashcards)
      return all_flashcards if ENV['FLASHCARDS']

      all_flashcards.filter_out(:new_flashcards) do |flashcard|
        flashcard.tags.include?(:new)
      end

      new_flashcards = all_flashcards.filtered_out_items(:new_flashcards)

      unless new_flashcards.empty?
        new_flashcards_text = new_flashcards.join_with_and { |flashcard| flashcard.expressions.first }
        warn "<blue.bold>~</blue.bold> <yellow.bold>Definition of these flashcards needs to be finished:</yellow.bold> #{new_flashcards_text}.".colourise
        warn "  Complete their definition and remove the <underline>new</underline> tag.\n\n".colourise
      end
    end

    # TODO: First test ones that has been tested before and needs refreshing before
    # they go to the long-term memory. Then test the new ones and finally the remembered ones.
    # Limit count of each.
    def select_flashcards_to_be_tested_on(all_flashcards, limit_per_run)
      return all_flashcards.active_items if ENV['FLASHCARDS']

      all_flashcards.filter(:recently_reviewed) do |flashcard|
        flashcard.with(@app).should_run?
      end

      flashcards_to_review = all_flashcards.reject { |flashcard| flashcard.with(@app).new? }
      new_flashcards = all_flashcards.select { |flashcard| flashcard.with(@app).new? }

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
            new_flashcards_limited = new_flashcards.shuffle[0..index]
            flashcards = flashcards_to_review_limited + new_flashcards_limited
          end
        end

        # puts ####
        # p [:flashcards, flashcards.map(&:translations)] ####
      else
        (new_flashcards + flashcards_to_review).shuffle
      end
    end

    def flashcards_to_be_tested_on
      if ENV['FLASHCARDS'] && @all_flashcards.has_filter?(:env)
        filtered_items_text = @all_flashcards.active_items.join_with_and { |flashcard| "<yellow>#{flashcard.expressions.first}</yellow>" }
        puts "<blue.bold>~</blue.bold> <green>Applying the env filter #{filtered_items_text}.</green>".colourise
      end

      self.filter_out_new_flashcards(@all_flashcards)
      self.filter_out_verbs_with_changed_conjugations(@all_flashcards)
      self.filter_out_unverified_verbs(@all_flashcards)

      @flashcards_to_be_tested_on ||= self.select_flashcards_to_be_tested_on(
        @all_flashcards,
        @config.limit_per_run
      )
    end
  end
end
