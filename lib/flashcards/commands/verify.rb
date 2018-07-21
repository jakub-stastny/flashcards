# frozen_string_literal: true

require 'socket'
require 'flashcards/command'
require 'refined-refinements/colours'

module Flashcards
  class VerifyCommand < SingleLanguageCommand
    using RR::ColourExts

    self.help = <<~EOF
      flashcards <red.bold>verify</red.bold>
    EOF

    def run
      app, args = self.get_args(@args)
      puts "~ Using language <yellow>#{app.language.name}</yellow>.".colourise

      report_unknown_flashcard_attributes(app.flashcards)

      require 'flashcards/wordreference'

      flashcards = app.flashcards
      if !(args & ['--force', '-f']).empty?
        # Reset checksums.
        flashcards.each do |flashcard|
          flashcard.metadata.delete(:checksum) if flashcard.with(app).verb
        end

        flashcards.filter(:verbs) do |flashcard|
          flashcard.with(app).verb
        end
      elsif args.empty?
        flashcards.filter(:verbs) do |flashcard|
          flashcard.with(app).verb
        end
      else
        flashcards.filter(:only_selected) do |flashcard|
          flashcard.with(app).verb && !(flashcard.expressions & args).empty?
        end
      end

      begin
        Flashcards::WordReference.run(app, flashcards)
      rescue SocketError
        abort "<red>Internet connection is required for this command to run.</red>".colourise
      end

      # Save the flashcards with updated metadata.
      flashcards.save
    end

    def report_unknown_flashcard_attributes(flashcards)
      flashcards_with_unknown_attributes = flashcards.reject do |flashcard|
        flashcard.unknown_attributes.empty?
      end

      unless flashcards_with_unknown_attributes.empty?
        flashcards_with_unknown_attributes.each do |flashcard|
          unknown_attributes_text = flashcard.unknown_attributes.join_with_and { |attribute| "<yellow>#{attribute}</yellow>" }
          warn "~ <yellow>#{flashcard.expressions.first}</yellow> has these unknown attributes: #{unknown_attributes_text}.".colourise
        end
        puts;
      end
    end
  end
end
