require 'flashcards/flashcard'

begin
  path = File.expand_path('~/.config/flashcards.yml')
  FLASHCARDS_DATA = File.new(path)
rescue Errno::ENOENT
  File.open(path, 'w') { }
  retry
end


def load_flashcards(data, language)
  data[language] ||= Array.new
  data[language].map { |flashcard_data| Flashcard.new(flashcard_data) }
end

def run(language, flashcards)
  puts "~ Testing your #{language} knowledge. Change system language to whatever language you want to practice.\n\n"

  # TODO: First test ones that has been tested before and needs refreshing before
  # they go to the long-term memory. Then test the new ones and finally the remembered ones.
  # Limit count of each.
  flashcards.shuffle.each do |flashcard|
    # TODO: also test remembered, but less so.
    next if flashcard.remembered?

    if synonyms = flashcards.select { |f2| flashcard.expression == f2.expression}
      print "#{flashcard.expression} (#{flashcard.hint || 'no hint'}): ".bold
    else
      print "#{flashcard.expression} (#{flashcard.hint || 'no hint'}) (not any of these: #{synonyms.map(&:expression).join(', ')}): ".bold
    end

    if flashcard.mark(STDIN.readline.chomp)
      puts "~ Well done! It is indeed '#{flashcard.translation.yellow.bold}'.".green.bold
      puts "~ Here are some examples:\n\n"
      flashcard.examples.each do |expression, translation|
        puts "  #{expression}".green, "  #{translation}".yellow, ''
      end
    else
      puts "~ It is in fact '#{flashcard.translation}'.".red
    end
  end
end
