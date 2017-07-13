# say -v '?' | grep es_
# es_AR: Diego
# es_ES: Jorge, Monica
# es_MX: Juan, Paulina
Flashcards.app.define_language(:es) do
  say_voice('Monica')
end

require_relative 'es/gerundio'
require_relative 'es/participio'

require_relative 'es/indicativo/presente'
require_relative 'es/indicativo/preterito'
require_relative 'es/indicativo/futuro'
require_relative 'es/indicativo/condicional'
require_relative 'es/indicativo/imperfecto'

# require_relative 'es/subjuntivo/presente'
# require_relative 'es/subjuntivo/preterito'
# require_relative 'es/subjuntivo/futuro'
#
require_relative 'es/imperativo/formal'
# require_relative 'es/imperativo/informal'
