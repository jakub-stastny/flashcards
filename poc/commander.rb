require 'curses'
# require 'refined-refinements/colours'
# using RR::ColourExts

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

def get_word_or_kbd_shortcut(window)
  Curses.noecho
  buffer = ''

  until (char = window.getch) == 13
    if char.is_a?(Integer) && char != 127 # Backspace
      raise KeyboardInterrupt.new(char) # TODO: Just return it, it's not really an error.
    elsif char == 127 # Backspace
      buffer = buffer[0..-2] # TODO: This doesn't work with the cursor.
      window.setpos(window.cury, 2) # TODO: use prompt.length
      window.addstr(buffer)
      window.refresh
    else
      window.addch(char)
      buffer << char
    end
  end

  Curses.echo
  window.setpos(window.cury + 1, 0)
  window.addstr([:input, buffer].inspect + "\n")
  window.refresh
  sleep 2.5
  return buffer
rescue KeyboardInterrupt => interrupt
  return interrupt
end

def commander_mode(flashcard)
  commander_window = Curses::Window.new(Curses.lines / 2 - 1, Curses.cols / 2 - 1, 0, 0)
  commander_window.addstr("Press e to edit, q to quit, v to tag as a verb ...\n\n")
  commander_window.refresh
  commander_mode_loop(commander_window, flashcard)
end

def commander_mode_loop(commander_window, flashcard)
  Curses.noecho
  commander_window.setpos(commander_window.cury, 0)
  case char = commander_window.getch
  when 'e'
    system "vim"
  when 'q'
    # Void, quit the commander.
  else
    commander_window.addstr("Unknown command #{char}.")
    commander_mode_loop(commander_window, flashcard)
  end
  Curses.echo
end

def main_add(input)
  return if input.empty?
  values = input.split(/\s*=\s*/)
  {expressions: values[0], translations: values[1]}
end

Curses.init_screen
Curses.start_color
Curses.nonl # enter is 13

begin
  loop do
    window = Curses::Window.new(Curses.lines / 2 - 1, Curses.cols / 2 - 1, 0, 0)

    # TODO: This should be in the parent window.
    window.addstr("Usage: expression 1, expression 2 = translation 1, translation 2 #tags\n")
    window.addstr("  Press Esc for the command mode to edit #{@last_flashcard.inspect}.\n") if @last_flashcard

    window.setpos(window.cury + 1, 0)
    window.addstr("> ")
    window.refresh

    input = get_word_or_kbd_shortcut(window)
    if input.is_a?(KeyboardInterrupt) && input.escape?
      if @last_flashcard
        commander_mode(@last_flashcard)
      else
        window.setpos(window.cury, 0)
        window.addstr("! No last flashcard, nothing to do.\n")
        window.refresh
        sleep 2
      end
    elsif input.is_a?(KeyboardInterrupt) && input.ctrl_d?
      exit
    elsif input.is_a?(KeyboardInterrupt)
      window.setpos(window.cury, 0)
      window.addstr("~ Unknown keyboard shortcut #{input.key_code}.")
      window.refresh
      sleep 2
    else
      @last_flashcard = main_add(input)
    end
  end
rescue Interrupt # Ctrl+C
ensure # Without this, there's no difference.
  Curses.close_screen
end
