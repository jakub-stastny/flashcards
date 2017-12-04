require 'date'
require 'flashcards/command'

module Flashcards
  class HasNotRunTodayCommand < SingleLanguageCommand
    # No help, this is semiprivate.
    # self.help = <<-EOF
    # EOF

    def last_review_time
      @app.flashcards.reduce(Time.now - (25 * 60 * 60)) do |newest_timestamp, flashcard|
        [newest_timestamp, flashcard.metadata[:last_review_time]].compact.max
      end
    end

    def last_test_time
      @app.flashcards.map { |f| f.correct_answers.values.flatten.sort.last }.compact.sort.last
    end

    def are_there_flashcards_for_review
      @app.flashcards.any? { |flashcard| flashcard.tags.include?(:new) }
    end

    def are_there_flashcards_to_be_tested_on
      @app.flashcards.any? do |flashcard|
        flashcard.with(@app).new? || flashcard.with(@app).time_to_review?
      end
    end

    def run
      @app = self.get_app(@args[0])

      has_been_reviewed_today = self.last_review_time.to_date == Date.today
      has_run_today = self.last_test_time.to_date == Date.today
      nothing_to_run_or_review = (! self.are_there_flashcards_for_review && ! self.are_there_flashcards_to_be_tested_on)

      if has_been_reviewed_today || has_run_today || nothing_to_run_or_review
        exit 1
      end
    end
  end
end
