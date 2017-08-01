# say -v '?' | grep es_
# fr_CA: Amelie
# fr_FR: Thomas
Flashcards::Language.define(:fr) do
  say_voice('Thomas')
end
