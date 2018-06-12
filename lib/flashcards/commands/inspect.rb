# frozen_string_literal: true

require 'flashcards/command'
require 'refined-refinements/colours'

module Flashcards
  class InspectCommand < SingleLanguageCommand
    using RR::ColourExts

    self.help = <<-EOF.gsub(/^\s*/, '')
      flashcards <blue.bold>inspect</blue.bold>
      flashcards <blue.bold>inspect</blue.bold> casi
      flashcards <blue.bold>inspect</blue.bold> casi.correct_answers.length ya.metadata
      flashcards inspect casi.correct_answers.values.flatten.length 'el problema.correct_answers.values.flatten.length' ya.correct_answers.values.flatten.length
    EOF

    def run
      app, args = self.get_args(@args)
      abort "Args cannot be empty." if args.empty?

      puts "~ Using language <yellow>#{app.language.name}</yellow>.".colourise
      flashcards = app.flashcards
      flashcards.each do |flashcard|
        next unless expression = args.find { |arg| flashcard.expressions.include?(arg.split('.').first) }
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
