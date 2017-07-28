require 'flashcards/command'

module Flashcards
  class InspectCommand < SingleLanguageCommand
    self.help = <<-EOF
      flashcards <blue.bold>inspect</blue.bold>
      flashcards <blue.bold>inspect</blue.bold> casi
      flashcards <blue.bold>inspect</blue.bold> casi.correct_answers.length ya.metadata
      flashcards inspect casi.correct_answers.values.flatten.length 'el problema.correct_answers.values.flatten.length' ya.correct_answers.values.flatten.length
    EOF

    def run
      args = self.get_args(argv)
      if args.empty?
        abort "Args cannot be empty."
      end

      puts "~ Using language <yellow>#{Flashcards.app.language.name}</yellow>.".colourise
      flashcards = Flashcards.app.flashcards
      flashcards.each do |flashcard|
        if expression = args.find { |arg| flashcard.expressions.include?(arg.split('.').first) }
          object = expression.split('.')[1..-1].reduce(flashcard) do |object, method|
            object.send(method)
          end
          if object.is_a?(Numeric) || object.is_a?(Symbol) || [true, false, nil].include?(object)
            puts "<green>#{expression}</green>: <blue.bold>#{object.inspect}</blue.bold>".colourise
          else
            puts "\n<green>#{expression}</green>:".colourise(bold: true)
            puts object.to_yaml
          end
        end
      end
    end
  end
end
