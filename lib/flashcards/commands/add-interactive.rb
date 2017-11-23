require 'flashcards/utils'
require 'flashcards/core_exts'
require 'refined-refinements/colours'
require 'refined-refinements/curses/app'

module Flashcards
  class AddInteractive
    using CoreExts
    using RR::ColourExts

    def initialize(app, command)
      @app, @command = app, command
      @log = File.open('pipe', 'w')
    end

    def run
      ::App.new.run do |app, window|
        window.write("<blue.bold>Usage</blue.bold>: <green>expression 1, expression 2</green> <magenta>=</magenta> <green>translation 1, translation 2</green> <yellow>#tags</yellow>\n\n")
        window.write("Press <bold>Esc</bold> for the command mode.\n\n")
        window.refresh

        line = app.readline("> ")

        values, tags = line.split(/\s+/).group_by { |word| word.match(/^#/) }.values
        values = values.join(' ').split(/\s*=\s*/)
        tags = tags || Array.new

        @log.puts([line, values, tags].inspect); @log.flush ####

        if values.length == 1
          @log.puts('A'); @log.flush ####
          matching_flashcards = Utils.matching_flashcards(@app.flashcards, values[0].split(/,\s*/))
          if matching_flashcards.empty?
            window.write("~ There is no definition yet.")
          else
            window.write("~ Flashcard #{matching_flashcards.join_with_and(&:to_s)} already exists.")
          end
          window.refresh; sleep 1 ### TODO: Write into a status line instead.
        elsif values.length == 2
          @log.puts('B'); @log.flush ####
          matching_flashcards = Utils.matching_flashcards(@app.flashcards, values[0].split(/,\s*/), values[1].split(/,\s*/))
          if matching_flashcards.empty?
            window.write("~ Adding <green>#{values.inspect}</green>#{" with tags #{tags.join_with_and { |tag| "<yellow>#{tag}</yellow>" }}" unless tags.empty?}.")
            @command.add(@app, values: values, tags: tags, args: '--no-edit') # Invoke the command in a non-interactive mode.
          else
            window.write("~ Flashcard #{matching_flashcards.join_with_and(&:to_s)} already exists.")
          end
          window.refresh; sleep 1 ### TODO: Write into a status line instead.
        else
          @log.puts('C'); @log.flush ####
          window.write("<red>!</red> Invalid input, try again.")
          window.refresh; sleep 1 ### TODO: Write into a status line instead.
        end
      end
    end
  end
end
