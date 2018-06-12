# frozen_string_literal: true

require 'refined-refinements/colours'

using RR::ColourExts

puts "Hey <bold>you</bold>!".colourise
puts "Hey <red>you</red> and <yellow>you</yellow>!".colourise(bold: true)
p "<green>Hey <red>you</red> and <yellow>you</yellow></green>!".colourise(bold: true)
