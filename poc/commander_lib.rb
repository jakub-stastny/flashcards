require 'curses'
require 'refined-refinements/colours'

using RR::ColourExts

class QuitError < StandardError
end

class App
  def initialize
    @history = Array.new
  end

  def run(&block)
    self.set_up

    loop do
      @current_window = window = Curses::Window.new(Curses.lines / 2 - 1, Curses.cols / 2 - 1, 0, 0)
      window.keypad = true
      block.call(self, window)
    end
  rescue Interrupt # Ctrl+C # TODO: Add Ctrl+D into this.
  ensure # TODO: Without this, there's no difference.
    Curses.close_screen
  end

  def set_up
    Curses.init_screen
    Curses.start_color
    Curses.nonl # enter is 13
  end

  def readline(prompt, &unknown_key_handler)
    Curses.noecho

    buffer, cursor, original_x = String.new, 0, @current_window.curx
    until (char = @current_window.getch) == 13
      begin
        buffer, cursor = process_char(char, buffer, cursor, @current_window, original_x)
      rescue KeyboardInterrupt => interrupt
        unknown_key_handler.call(interrupt) if unknown_key_handler
      end

      sp = ' ' * (@current_window.maxx - @current_window.curx - buffer.length - 2)
      # @current_window.deleteln
      @current_window.setpos(@current_window.cury, original_x)
      @current_window.write(buffer + sp)

      # DBG
      a, b = @current_window.cury, cursor + original_x
      @current_window.setpos(@current_window.cury + 1, 0)
      @current_window.write("<blue.bold>~</blue.bold> DBG: X position <green>#{original_x}</green>, cursor <green>#{cursor}</green>, buffer <green>#{buffer.inspect}</green>, history: <green>#{@history.inspect}</green> ... writing to <green>#{a}</green> x <green>#{b}</green>")
      @current_window.setpos(@current_window.cury - 1, cursor + original_x)

      @current_window.refresh
    end

    @history << buffer
    Curses.echo
    @current_window.setpos(@current_window.cury + 1, 0)
    @current_window.write([:input, buffer].inspect + "\n")
    @current_window.refresh
    sleep 2.5
    return buffer
  end

  def commander(help, &handler)
    commander_window = Curses::Window.new(Curses.lines / 2 - 1, Curses.cols / 2 - 1, 0, 0)
    commander_window.write(help)
    commander_window.refresh

    commander_mode_loop(commander_window, &handler)
  end

  private
  def commander_mode_loop(commander_window, &handler)
    Curses.noecho
    commander_window.setpos(commander_window.cury, 0)
    handler.call(commander_window, commander_window.getch)
  rescue QuitError
    # void
  ensure
    Curses.echo
  end

  def process_char(char, buffer, cursor, window, original_x)
    case char
    when 127 # Backspace.
      unless buffer.empty?
        buffer = buffer[0..-2]; cursor -= 1
      end
    when 258 # Down arrow
      # TODO
      window.write("X")
      window.refresh
    when 259 # Up arrow.
      # TODO:
      @history_index ||= @history.length - 1

      window.setpos(window.cury + 1, 0)
      window.write("DBG: #{@history_index}, #{(0..@history.length).include?(@history_index)}")
      window.setpos(window.cury - 1, cursor + original_x)
      window.refresh

      if (0..@history.length).include?(@history_index)
        @buffer_before_calling_history = buffer
        buffer = @history[@history_index - 1]
      else
        window.setpos(window.cury, 0)
        if @history.empty?
          window.write("~ The history is empty.")
        else
          window.write("~ Already at the first item.")
        end
        window.setpos(window.cury - 1, original_x)
        window.refresh
      end
      cursor = buffer.length
    when 260 # Left arrow.
      cursor -= 1 unless original_x == window.curx
      # window.setpos(window.cury, window.curx - 1)
    when 261 # Right arrow.
      cursor += 1 unless original_x + buffer.length == window.curx
      # window.setpos(window.cury, window.curx + 1)
    when String
      # window.addch(char)
      buffer.insert(cursor, char); cursor += 1
    else
      raise KeyboardInterrupt.new(char) # TODO: Just return it, it's not really an error.
    end

    return buffer, cursor
  end
end
