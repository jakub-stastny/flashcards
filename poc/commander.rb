require_relative 'commander_lib'
require 'refined-refinements/colours'

using RR::ColourExts

# TODO:
# - History (up/down keys)
# - Colours, so we can use what I already have.
# - Backspace handling, left/right arrows, Ctrl+a, Ctrl+e, Ctrl+k, delete.

class KeyboardInterrupt < StandardError
  attr_reader :key_code
  def initialize(key_code)
    @key_code = key_code
  end

  def escape?
    @key_code == 27
  end

  def ctrl_d?
    @key_code == 4
  end
end

def main_add(input)
  return if input.empty?
  values = input.split(/\s*=\s*/)
  {expressions: values[0], translations: values[1]}
end

################################################################################
App.new.run do |app, window|
  # TODO: This should be in the parent window.
  window.write("<green.bold>Usage:</green.bold> <white>expression <red>1</red>, expression 2</white> <magenta>=</magenta> translation 1, translation 2 #tags\n")
  window.write("  Press Esc for the command mode to edit #{@last_flashcard.inspect}.\n") if @last_flashcard

  window.setpos(window.cury + 1, 0)
  window.write("> ")
  window.refresh

  input = app.readline('prompt') do |key|
    raise key unless key.key_code == 27 # Escape.

    if @last_flashcard
      app.commander("Press e to edit, q to quit, v to tag as a verb ...") do |commander_window, char|
        case char
        when 'e'
          system "vim"
        when 'q'
          # Void, quit the commander.
        else
          commander_window.write("Unknown command #{char.inspect}.")
          commander_mode_loop(commander_window, flashcard) # TODO: Do it the other way probably, exception/:quit to quit, otherwise continue.
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
