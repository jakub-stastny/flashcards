module Flashcards
  module Utils
    def self.edit_flashcard(flashcard)
      path = "/tmp/#{flashcard.expressions.first.tr(' ', '_')}.yml"

      if File.exist?(path) # Give a chance to edit incorrect data.
        # TODO: Compare if anything changed.
        File.open(path, 'a') do |file|
          file.rewind
          file.puts("# NOTE: This file has been created at #{File.mtime(file)}.")
          file.puts("# The data here may not be up to date with the current version.")
        end
      else
        File.open(path, 'w') do |file|
          file.puts(
            "# Verb checklist:",
            "# - Is it tagged as verb?",
            "# - Does it have reflexive form?",
            "# - Is it irregular?")
          file.puts(flashcard.expanded_data.to_yaml)
        end
      end

      system("vim #{path}")

      flashcard_data = YAML.load_file(path)

      if flashcard_data.nil?
        File.unlink(path) && return
      end

      flashcard = Flashcard.new(flashcard_data)

      File.unlink(path)

      flashcard
    end
  end
end
