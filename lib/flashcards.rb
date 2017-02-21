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
  data[language].map do |flashcard_data|
    begin
      Flashcard.new(flashcard_data)
    rescue => error
      abort "Loading flashcard #{flashcard_data.inspect} failed: #{error.message}"
    end
  end
end

def run(language, flashcards)
  puts "~ Testing your #{language} knowledge. Change system language to whatever language you want to practice.\n\n"

  # TODO: First test ones that has been tested before and needs refreshing before
  # they go to the long-term memory. Then test the new ones and finally the remembered ones.
  # Limit count of each.
  flashcards.shuffle.each do |flashcard|
    # TODO: also test remembered, but less so.
    next if flashcard.remembered?

    sample = flashcard.examples.sample
    puts sample[0].
      sub(flashcard.expression, flashcard.expression.bold).
      sub(flashcard.expression.sub(/^./) { $&.upcase}, flashcard.expression.sub(/^./) { $&.upcase}.bold)
    if synonyms = flashcards.select { |f2| flashcard.expression == f2.expression}
      print "#{flashcard.expression}#{" (#{flashcard.hint})" if flashcard.hint}: ".bold
    else
      print "#{flashcard.expression} (#{flashcard.hint || 'no hint'}) (not any of these: #{synonyms.map(&:expression).join(', ')}): ".bold
    end

    if flashcard.mark(translation = STDIN.readline.chomp)
      synonyms = flashcard.translations - [translation]
      puts "~ Well done! It is indeed '#{translation.yellow.bold}''#{" or #{synonyms.join(', ').yellow.bold}" unless synonyms.empty?}.".green.bold
      # puts "~ Synonyms are #{synonyms.join(', ').yellow.bold}".bold unless synonyms.empty?
      puts "~ Here are some examples:\n\n"
    else
      synonyms = flashcard.translations[1..-1]
      puts "~ It is in fact '#{flashcard.translations[0].yellow}'#{" or #{synonyms.join(', ').yellow}" unless synonyms.empty?}.".red
    end

    flashcard.examples.each do |expression, translation|
      puts "  #{expression}".green, "  #{translation}".yellow, ''
    end
  end
end
