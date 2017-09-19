require 'socket'
require 'flashcards/command'
require 'refined-refinements/colours'

module Flashcards
  class VerifyCommand < SingleLanguageCommand
    using RR::ColourExts

    self.help = <<-EOF
      flashcards <red.bold>verify</red.bold>
    EOF

    def run
      app, args = self.get_args(@args)
      puts "~ Using language <yellow>#{app.language.name}</yellow>.".colourise

      require 'flashcards/wordreference'

      flashcards = app.flashcards
      flashcards_with_unknown_attributes = flashcards.select do |flashcard|
        ! flashcard.unknown_attributes.empty?
      end

      unless flashcards_with_unknown_attributes.empty?
        flashcards_with_unknown_attributes.each do |flashcard|
          unknown_attributes_text = flashcard.unknown_attributes.join_with_and { |attribute| "<yellow>#{attribute}</yellow>" }
          warn "~ <yellow>#{flashcard.expressions.first}</yellow> has these unknown attributes: #{unknown_attributes_text}.".colourise
        end
        puts;
      end

      unless args.empty?
        flashcards.filter(:only_selected) do |flashcard|
          not (flashcard.expressions & args).empty?
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
  end
end
