# say -v '?' | grep es_
# es_AR: Diego
# es_ES: Jorge, Monica
# es_MX: Juan, Paulina
Flashcards::Language.define(:es) do
  say_voice('Monica')
  accents_help("<blue.bold>~</blue.bold> <green>Writing accents:</green> <red>á</red> <bright_black>⌥-e a</bright_black>   <blue>ñ</blue> <bright_black>⌥-n n</bright_black>   <yellow>ü</yellow> <bright_black>⌥-u u</bright_black>   <magenta>¡</magenta> <bright_black>⌥-1</bright_black>   <magenta>¿</magenta> <bright_black>⌥-⇧-?</bright_black>")

  require_relative 'es/syllabifier'
  syllabifier(Flashcards::ES::Syllabifier)
end


require_relative 'es/gerundio'
require_relative 'es/participio'

require_relative 'es/indicativo/presente'
require_relative 'es/indicativo/preterito'
require_relative 'es/indicativo/futuro'
require_relative 'es/indicativo/condicional'
require_relative 'es/indicativo/imperfecto'

require_relative 'es/subjuntivo/presente'
require_relative 'es/subjuntivo/imperfecto'
require_relative 'es/subjuntivo/futuro'

require_relative 'es/imperativo/formal'
require_relative 'es/imperativo/positivo'
require_relative 'es/imperativo/negativo'
