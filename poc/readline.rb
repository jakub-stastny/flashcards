# frozen_string_literal: true

require 'readline'

# What works:
# - Moving the cursor, backspace, delete.
# - History (arrows and even Ctrl+r).
# - Ctrl+a, Ctrl+e, Ctrl+k and Ctrl+y.
loop do
  input = Readline.readline('> ', true)
  if input == 'h'
    p Readline::HISTORY.to_a
  else
    p input
  end
end
