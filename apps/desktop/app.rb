#!/usr/bin/env shoes
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('flashcards../lib', __dir__))

require 'flashcards/commander'

ENV['FF'] ||= '/tmp/test.yml' #File.expand_path('~/.config/flashcards.yml')
ENV['EDITOR_APP'] ||= 'Atom'

TAG_LIST = [:verb, :reflective].freeze

Shoes.app(width: 600, height: 570) do
  background '#EFC'
  border('#BE8', strokewidth: 6)

  stack margin: 40 do
    # stack margin: 10 do
    #   para strong('Language')
    #   @name = list_box items: ['Spanish', 'Polish', 'English']
    # end

    stack margin: 10 do
      flow do
        para strong('Foreign word ')
        para '*', stroke: red
      end

      flow do
        @expressions = edit_line(width: 250)
        para strong('Example:'), 'todavía, aún', stroke: gray, margin: [20, 7, 0, 0]
      end
    end

    stack margin: 10 do
      flow do
        para strong('Translation ')
        para '*', stroke: red
      end

      flow do
        @translations = edit_line(width: 250)
        para strong('Example:'), 'still, even', stroke: gray, margin: [20, 7, 0, 0]
      end
    end

    # stack margin: 10 do
    #   flow do
    #     para strong('Silent translation  '), stroke: gray
    #     para '*', stroke: red
    #   end
    #   para 'Synonyms which won\'t make it to the list of synonyms. If in doubt, leave blank.', stroke: gray
    #   para 'Example: If the word is uno and translation one, silent translation can be 1.', stroke: gray
    #   @silent_translations = edit_line(width: 250)
    # end

    stack margin: 10 do
      flow do
        para '*', stroke: red
        para 'This can be a list of words separated by comma.'
      end
    end

    stack margin: 10 do
      para strong('Note'), stroke: gray
      para 'Note will be displayed after your answer.', stroke: gray
      @note = edit_box(width: 250, height: 55)
    end

    stack margin: 10 do
      para strong('Tags'), stroke: gray
      flow do
        @tag_list_checks = TAG_LIST.map do |tag|
          checkbox = check; para(tag.to_s)
          [checkbox, tag]
        end
      end
    end

    stack margin: 10 do
      @example_lines = Array.new
      para strong('Examples'), stroke: gray
      3.times do
        flow do
          @example_lines << [
            edit_line(width: 250), edit_line(width: 250)
          ]
        end
      end
    end

    stack margin: 10 do
      flow do
        button 'Save' do
          tags = @tag_list_checks.
            select { |checkbox, _| checkbox.checked? }.
            map { |_, tag| tag }

          examples = @example_lines.map { |expression, translation|
            unless [expression.text, translation.text].any?(&:empty?)
              Example.new(expression.text, translation.text)
            end
          }.compact

          arguments = {
            expressions: @expressions.text.split(/\s*,\s*/),
            translations: @translations.text.split(/\s*,\s*/),
            # silent_translations: @silent_translations.text.split(/\s*,\s*/),
            tags: tags,
            examples: examples,
            note: @note.text
          }

          begin
            flashcard = Flashcard.new(arguments)
          rescue ArgumentError => error
            puts "~ Flashcard arguments: #{arguments.inspect}"
            alert(error.message)
          else
            puts "~ Flashcard: #{flashcard.inspect}"

            Flashcards::Commander.add_flashcard(flashcard)

            @expressions.text = ''
            @translations.text = ''
            @translations.text = ''
            @note.text = ''
            @tag_list_checks.each { |checkbox, _| checkbox.checked = false }
            @example_lines.flatten.each { |line| line.text = '' }
          end
        end

        button 'Run' do
          system 'osascript launch_flashcards_in_terminal.scpt'
        end

        button 'Edit' do
          system "open -a #{ENV['EDITOR_APP']} '#{ENV['FF']}'"
        end
      end
    end
  end
end
