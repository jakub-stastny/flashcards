# frozen_string_literal: true

require 'flashcards/command'
require 'flashcards/config'
require 'refined-refinements/colours'

module Flashcards
  class InitCommand < GenericCommand
    using RR::ColourExts

    self.help = <<~EOF
      flashcards <magenta>init</magenta> es pl
    EOF

    def run
      if @args.empty? || @args.any? { |code| !code.match(/^[a-z]{2}$/) }
        abort <<~EOF.colourise
          Please provide one or more language codes as arguments.
          The codes are expected to be two characters long (such as <red>es</red>).

          For instance: <bright_black>flashcards init cz</bright_black>
        EOF
      end

      if File.exist?(Flashcards::Config::DEFAULT_CONFIG_PATH)
        warn "~ File <bright_black>#{Flashcards::Config::DEFAULT_CONFIG_PATH}</bright_black> already exists, adding new languages.".colourise
        config = Flashcards::Config.new

        @args.each do |language_code|
          if config.data['learning'].key?(language_code)
            warn "~ Language #{language_code} has already been initiated.".colourise
          else
            config.data['learning'][language_code] = Hash.new
          end
        end

        puts "~ Saving the config.".colourise
        config.save
      else
        config = Flashcards::Config.new
        config.data = {'learning' => @args.reduce(Hash.new) { |buffer, lang_code| buffer.merge(lang_code => Hash.new) }}
        config.save
      end
    end
  end
end
