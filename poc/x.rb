# frozen_string_literal: true

require 'curses'

class KeyboardInterrupt < StandardError
  attr_reader :key_code
  def initialize(key_code)
    @key_code = key_code
  end
end

def get_word_or_kbd_shortcut
  buffer = ''

  until (char = Curses.getch) == 13
    if char.is_a?(Integer)
      p [:kbd, char]
      raise KeyboardInterrupt.new(char)
    else
      buffer << char
    end
  end

  return buffer
end

Curses.init_screen
Curses.start_color

PAIRS = {'hello' => 'hola', 'to have' => 'tener', 'to do' => 'hacer'}

begin
  Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_BLUE)
  Curses.attrset(Curses.color_pair(1) | Curses::A_BLINK)
  Curses.addstr("Hello World")

  loop do
    Curses.setpos(0, 0)
    Curses.addstr("¡Hola!")
    #Curses.refresh
    #Curses.noecho
    #Curses.nocbreak
    Curses.nonl # enter is 13
    #p Curses.getch
    Curses.setpos(2, 0)
    #Curses.addstr(Curses.getch.to_s)
    #Curses.addstr(Curses.getstr.inspect)

    key = PAIRS.keys.sample
    Curses.addstr("#{key} in Spanish: ")
    input = Curses.getstr
    # input = get_word_or_kbd_shortcut
    if input == PAIRS[key]
      Curses.addstr("v #{input}")
    else
      Curses.addstr("x #{input}")
    end
  end
ensure
  Curses.close_screen
end
