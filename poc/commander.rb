require 'refined-refinements/curses/app'

using RR::ColourExts

def main_add(input)
  return if input.empty?
  values = input.split(/\s*=\s*/)
  {expressions: values[0], translations: values[1]}
end

################################################################################
App.new.run do |app, window|
  # TODO: This should be in the parent window.
  window.write("<green.bold>Usage:</green.bold> <white>expression <red>1</red>, expression 2</white> <magenta>=</magenta> translation 1, translation 2 #tags\n")
  window.write("  Press <bright_black>Esc</bright_black> for the command mode to edit #{@last_flashcard.inspect}.\n") if @last_flashcard

  window.setpos(window.cury + 1, 0)
  window.write("> ")
  window.refresh

  input = app.readline('prompt') do |key|
    raise key unless char == 27 # Escape.

    if @last_flashcard
      app.commander("Press <green>e</green> to edit, <red>q</red> to quit, <magenta>v</magenta> to tag as a verb ...") do |commander_window, char|
        case char
        when 'e'
          system "vim"
        when 'q'
          # Void, quit the commander.
          raise QuitError
        else
          commander_window.write("Unknown command #{char}.")
          commander_window.refresh
        end
      end
    else
      # TODO: Find a better solution, like status line (separate window).
      window.setpos(window.cury, 0)
      window.write("! No last flashcard, nothing to do.\n")
      window.refresh
      sleep 2
    end
  end

  @last_flashcard = main_add(input)
end
