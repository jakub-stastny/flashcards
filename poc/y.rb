# frozen_string_literal: true

require 'rubygems'
require 'ncurses'

screen = Ncurses.initscr
Ncurses.noecho
Ncurses.cbreak
Ncurses.start_color

screen.addstr(Ncurses.COLORS.to_s)
screen.getch

Ncurses.curs_set 0
Ncurses.move 0, 0
Ncurses.clear
Ncurses.refresh
cc = Ncurses.COLORS
begin
color_count = 0
cc.times do |bg|
  cc.times do |fg|
    Ncurses.init_pair(color_count, fg, bg)
    screen.attron(Ncurses.COLOR_PAIR(color_count))
    screen.addstr("#")
    screen.attroff(Ncurses.COLOR_PAIR(color_count))
    color_count += 1
  end
  screen.addstr("== #{bg} ===\n")
  #if bg % 8 == 0
  #  Ncurses.refresh
  ch = screen.getch
  break if ch == 'q'
  Ncurses.clear
  color_count = 0
  #end
end
# color_count.times do |i|
#   screen.attrset(Ncurses.COLOR_PAIR(i))
#   screen.addstr("#")
# end
ensure
Ncurses.endwin
end
