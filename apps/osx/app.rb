#!/usr/bin/env shoes
# frozen_string_literal: true

require 'flashcards'

ENV['FF'] ||= '/tmp/test.yml' #File.expand_path('~/.config/flashcards.yml')
ENV['EDITOR_APP'] ||= 'Atom'

Shoes.app(width: 600) do
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
      @note = edit_box(width: 250)
    end

    stack margin: 10 do
      para strong('Tags'), stroke: gray
      para 'This can be a list of words separated by comma.', stroke: gray
      @tags = edit_line(width: 250)
    end

    stack margin: 10 do
      para strong('Examples'), stroke: gray
      flow do
        @example_1 = edit_line(width: 250)
        @example_2 = edit_line(width: 250)
      end
      flow do
        @example_1 = edit_line(width: 250)
        @example_2 = edit_line(width: 250)
      end
      flow do
        @example_1 = edit_line(width: 250)
        @example_2 = edit_line(width: 250)
      end
    end

    stack margin: 10 do
      flow do
        button 'Save' do
          flashcard = Flashcard.new(
            expressions: @expressions.text.split(/\s*,\s*/),
            translations: @translations.text.split(/\s*,\s*/),
            # silent_translations: @silent_translations.text.split(/\s*,\s*/),
            tags: @tags.text.split(/\s*,\s*/).map(&:to_sym),
            note: @note.text)
          p flashcard

          # TODO: Write to the file, reset the form.
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
