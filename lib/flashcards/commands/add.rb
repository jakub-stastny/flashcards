# frozen_string_literal: true

require 'flashcards/command'
require 'flashcards/commands/add-interactive'
require 'flashcards/utils'
require 'refined-refinements/colours'

  # <magenta>Multilingual mode</magenta> If you have more than one language configured in your
  #   <bright_black>~/.config/flashcards.yml</bright_black>, you can specify which one you want to add the
  #   flashcard into. Note that you don't have to do so if you have one
  #   langugage marked as the default one, but you always can.
  #
  #   flashcards <red>add</red> <yellow>es</yellow> todavía still
  #   flashcards <red>add</red> todavía<bright_black> # Check if a flashcard is defined.</bright_black>
  #   --no-edit #verb
module Flashcards
  class AddCommand < SingleLanguageCommand
    using RR::ColourExts
    using CoreExts

    self.help = <<-EOF.gsub(/^\s*/, '')
      #{self.main_command} <red>+</red> [word] [translations]
      #{self.main_command} <red>+</red> todavía still
      #{self.main_command} <red>+</red> casi almost,nearly  <bright_black># Add multiple translations.</bright_black>
      #{self.main_command} <red>+</red> dónde,adónde where  <bright_black># Add multiple expressions.</bright_black>
      #{self.main_command} <red>+</red> dar 'to give' <yellow>#verb</yellow> <bright_black># Add with a tag.</bright_black>
    EOF

    def process_arguments
      app, args = self.get_args(@args)
      args = args.group_by do |item|
        case item
        when /^-/ then :args
        when /^#/ then :tags
        else :values end
      end

      args.default_proc = Proc.new { |hash, key| hash[key] = Array.new }
      return app, args
    end

    def run
      app, args = self.process_arguments

      if args[:values].empty?
        self.run_interactive(app, args)
      elsif args[:values].length == 1
        matching_flashcards = Utils.matching_flashcards(app.flashcards, args[:values][0].split(/,\s*/), Array.new)
        possibly_matching_flashcards = Utils.possibly_matching_flashcards(app.flashcards, args[:values][0].split(/,\s*/), Array.new)

        if matching_flashcards.empty? && possibly_matching_flashcards.empty?
          puts "There is no definition for <yellow>#{args[:values][0]}</yellow> yet.".colourise
        elsif possibly_matching_flashcards.empty?
          matching_flashcards_text = matching_flashcards.map { |f|
            a = f.expressions.join_with_and  { |word| "<yellow>#{word}</yellow>" }
            b = f.translations.join_with_and { |word| "<green>#{word}</green>" }
            "#{a}: #{b}"
          }.join("\n- ")
          puts "<magenta>Matching flashcards:</magenta>\n- #{matching_flashcards_text}".colourise
        else
          matching_flashcards_text = possibly_matching_flashcards.map { |f|
            a = f.expressions.join_with_and  { |word| "<yellow>#{word}</yellow>" }
            b = f.translations.join_with_and { |word| "<green>#{word}</green>" }
            "#{a}: #{b}"
          }.join("\n- ")
          puts "<magenta>Possibly matching flashcards:</magenta>\n- #{matching_flashcards_text}".colourise
        end
      elsif args[:values].length == 2
        self.add(app, args)
      else
        # TODO: Commander::HELP_ITEMS[:add]
        abort "Usage: #{File.basename($0)} [lang] [word] [translation] [tags]"
      end
    end

    def add(app, args)
      flashcards = app.flashcards

      expressions  = args[:values][-2].split(/,\s*/)
      translations = args[:values][-1].split(/,\s*/)

      flashcards.each do |flashcard|
        if (! (flashcard.expressions & expressions).empty?) && (! (flashcard.translations & translations).empty?)
          abort "Same flashcard: #{flashcard}.".colourise
        end
      end

      flashcard = self.sample_flashcard(args)

      if args[:args].include?('--no-edit')
        flashcard.examples.clear
        flashcard.metadata.clear
        flashcard.tags << :new
        flashcards << flashcard
        flashcards.save
      else
        if flashcard = Utils.edit_flashcard(flashcard)
          unless flashcard.tags.include?(:delete)
            flashcards << flashcard
            flashcards.save
          else
            abort "Delete tag detected. Aborted."
          end
        else
          abort "No data found."
        end
      end
    end

    def sample_flashcard(args)
      Flashcard.new(
        expressions: args[:values][0].split(/,\s*/),
        translations: args[:values][1].split(/,\s*/),
        tags: (args[:tags] || Array.new).map { |tag| tag[1..-1].to_sym },
        examples: Array.new,
        metadata: {
          last_review_time: Time.now
        }
      )
    end

    def run_interactive(app, args)
      Flashcards::AddInteractive.new(app, self).run
    end
  end
end
