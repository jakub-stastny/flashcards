require 'flashcards/command'

module Flashcards
  class HasNotRunTodayCommand < SingleLanguageCommand
    # No help, this is semiprivate.
    # self.help = <<-EOF
    # EOF

    def run
      app = self.get_app(@args[0])
      flashcards = app.flashcards.map { |flashcard| flashcard.with(app) }
      to_be_reviewed = flashcards.count(&:time_to_review?)
      new_flashcards = flashcards.count(&:new?)

      exit 1 if (to_be_reviewed + new_flashcards) == 0

      last_review_at = app.flashcards.map { |f| f.correct_answers.values.flatten.sort.last }.compact.sort.last

      run_today = last_review_at && last_review_at.to_date == Date.today
      exit 1 if run_today
    end
  end
end
