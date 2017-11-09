require 'flashcards/command'
require 'refined-refinements/colours'

module Flashcards
  class ConsoleCommand < SingleLanguageCommand
    using RR::ColourExts

    self.help = <<-EOF.gsub(/^\s*/, '')
      flashcards <magenta>console</magenta>
      flashcards <magenta>console</magenta> es
    EOF

    def run
      @app = self.get_app(*@args)
      puts "~ Using language <yellow>#{@app.language.name}</yellow>.".colourise

      app = @app; fs = app.flashcards; ts = app.tests

      ###################################################################
      # Help: app,                                                      #
      #       app.flashcards (or fs), app.tests (or ts),                #
      #       fs[:expressions, 'la cama']
      #       app.flashcards.save                                       #
      #                                                                 #
      # Use ser or ser_verb to retrieve a flashcard or its verb object. #
      ###################################################################

      require 'pry'; binding.pry
    end

    def method_missing(method_name, *args, &block)
      if args.empty? && block.nil?
        expression = method_name.to_s.sub(/_verb$/, '').tr('_', ' ')
        flashcard  = @app.flashcards[:expressions, expression].first
        method_name.match(/_verb$/) ? flashcard.with(@app).verb : flashcard
      else
        super(*args, &block)
      end
    end
  end
end
