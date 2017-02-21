require 'flashcards/flashcard'

begin
  path = File.expand_path(ENV['FF'] || '~/.config/flashcards.yml')
  FLASHCARDS_DATA = File.new(path)
rescue Errno::ENOENT
  File.open(path, 'w') { }
  retry
end

class Array
  def join_with_and(xxx = 'and', delimiter = ', ')
    return self[0] if self.length == 1
    "#{self[0..-2].join(delimiter)} #{xxx} #{self[-1]}"
  end
end

class String
  def titlecase
    "#{self[0].upcase}#{self[1..-1]}"
  end
end

def load_flashcards(flashcard_data)
  flashcard_data.map do |flashcard_data|
    begin
      Flashcard.new(flashcard_data)
    rescue => error
      abort "Loading flashcard #{flashcard_data.inspect} failed: #{error.message}"
    end
  end
end

def load_do_then_save(&block)
  data = YAML.load(FLASHCARDS_DATA.read) || Array.new

  flashcards = load_flashcards(data)
  data = block.call(flashcards)

  FLASHCARDS_DATA.close
  yaml = data.to_yaml
  File.open(FLASHCARDS_DATA.path, 'w') { |file| file << yaml }
end

$correct = 0; $incorrect = 0
def run(flashcards)
  # TODO: First test ones that has been tested before and needs refreshing before
  # they go to the long-term memory. Then test the new ones and finally the remembered ones.
  # Limit count of each.
  flashcards.shuffle.each do |flashcard|
    # TODO: also test remembered, but less so.
    next if flashcard.remembered?

    if sample = flashcard.examples.sample
      puts '', sample[0].
        sub(flashcard.expression, flashcard.expression.bold).
        sub(flashcard.expression.titlecase, flashcard.expression.titlecase.bold)
    else
      puts
    end

    if synonyms = flashcards.select { |f2| flashcard.expression == f2.expression }
      print "#{flashcard.expression}#{" (#{flashcard.hint})" if flashcard.hint}: ".bold
    else
      print "#{flashcard.expression}#{" (#{flashcard.hint})" if flashcard.hint} (not any of these: #{synonyms.map(&:expression).join(', ')}): ".bold
    end

    if flashcard.mark(translation = $stdin.readline.chomp)
      $correct += 1
      synonyms = flashcard.translations - [translation]
      puts colourise("  <green>✔︎  </green>" +
        "<yellow>#{flashcard.expression.titlecase}</yellow> " +
        "<green>is indeed <yellow>#{translation}</yellow>. </green>" +
        (synonyms.any? ? "<green>It can also mean</green> #{synonyms.map { |word| "<yellow>#{word}</yellow>" }.join_with_and('or')}<green>.</green>" : '') +
        "\n", bold: true)
    else
      $incorrect += 1
      list = flashcard.translations.map do |word|
        word
        "<yellow>#{word}</yellow>"
      end.join_with_and('<red>or</red>')

      puts colourise("  <red>✘  #{flashcard.expression.titlecase} is </red>#{list}.\n", bold: true)
    end

    puts unless flashcard.examples.empty?
    flashcard.examples.each do |expression, translation|
      puts colourise("     <cyan>#{expression}</cyan>")
      puts colourise("     <magenta>#{translation}</magenta>\n\n")
    end
  end

  puts colourise("\n<green>Statistics</green>", bold: true)
  puts colourise("- <bold>Total:</bold> #{$correct + $incorrect} (" +
    [("<green>#{$correct} correct</green>" unless $correct == 0),
      ("<red>#{$incorrect} incorrect</red>" unless $incorrect == 0)].compact.join(' and ') + ').')
  # puts "- Review"
  # puts "- New vocabulary:"
rescue Interrupt
  # TODO: Save current progress (metadata).
  puts; exit
end

# NOTE: The recursion is to add support for parsing nesting, such as in <green>1<yellow>2</yellow>.</green>
# TODO: Nesting still doesn't work, i. e. in <green>✔︎ <yellow>Todavía</yellow> is indeed <yellow>still</yellow>. </green>
# That's because we don't know which scope are we in (what tags are open).
def colourise(string, options = Hash.new)
  result = string.gsub(/<([^>]+)>(.+?)<\/\1>/m) do |match|
    methods = $1.split('.')
    methods.push(:bold) if options[:bold]
    methods.reduce($2) do |result, method|
      result.send(method)
    end
  end

  result.match(/<([^>]+)>(.+?)<\/\1>/m) ? colourise(result) : result
end
