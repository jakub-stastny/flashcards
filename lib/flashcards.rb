require 'flashcards/flashcard'

begin
  path = File.expand_path('~/.config/flashcards.yml')
  FLASHCARDS_DATA = File.new(path)
rescue Errno::ENOENT
  File.open(path, 'w') { }
  retry
end

class Array
  def join_with_and(xxx = 'and', delimiter = ', ')
    "#{self[0..-2].join(delimiter)} #{xxx} #{self[-1]}"
  end
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
  puts ["~ Testing your ".bold, language.cyan.bold, " knowledge. Change system language to whatever language you want to practice.\n".bold].join

  # TODO: First test ones that has been tested before and needs refreshing before
  # they go to the long-term memory. Then test the new ones and finally the remembered ones.
  # Limit count of each.
  flashcards.shuffle.each do |flashcard|
    # TODO: also test remembered, but less so.
    next if flashcard.remembered?

    if sample = flashcard.examples.sample
      puts sample[0].
        sub(flashcard.expression, flashcard.expression.bold).
        sub(flashcard.expression.sub(/^./) { $&.upcase }, flashcard.expression.sub(/^./) { $&.upcase }.bold)
    else
      puts
    end

    if synonyms = flashcards.select { |f2| flashcard.expression == f2.expression }
      print "#{flashcard.expression}#{" (#{flashcard.hint})" if flashcard.hint}: ".bold
    else
      print "#{flashcard.expression}#{" (#{flashcard.hint})" if flashcard.hint} (not any of these: #{synonyms.map(&:expression).join(', ')}): ".bold
    end

    if flashcard.mark(translation = STDIN.readline.chomp)
      synonyms = flashcard.translations - [translation]
      list = synonyms.map { |word| ["'".green.bold, word.yellow.bold, "'".green.bold].join }.join_with_and('or'.green.bold)
      puts ["~ Well done! It is indeed '".green.bold, translation.yellow.bold, "'".green.bold, (list unless synonyms.empty?), ".".green.bold, "\n\n"].join
    else
      synonyms = flashcard.translations[1..-1]
      list = synonyms.map { |word| ["'".red.bold, word.yellow.bold, "'".red.bold].join }.join_with_and('or'.red.bold)
      puts ["~ It is in fact '".red.bold, translation.yellow.bold, "'".red.bold, (list unless synonyms.empty?), ".".red.bold, "\n\n"].join
    end

    flashcard.examples.each do |expression, translation|
      puts "  #{expression}".green, "  #{translation}".yellow, ''
    end
  end
rescue Interrupt
  # TODO: Save current progress (metadata).
  puts; exit
end
