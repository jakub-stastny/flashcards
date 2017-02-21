# About

Flashcards for learning languages.

## Tutorial

First we have to add a few flashcards. Let's say you're learning Spanish.

```shell
flashcards add es todavía still
flashcards add es casi almost,nearly
```

And run `flashcards`. Here you go!

![flashcards-1]()

This is just the basics though. It's important to learn in context, so let's
make it more useful and add some examples.

Run `flashcards edit`.

When you re-run `flashcards`, you should get something more fun:

![flashcards-2]()

## Syntax of `~/.config/flashcards.yml`

```yaml
---
es:
- :expression: todavía
  :examples:
  - - "¿Todavía estás en la cama?"
    - Are you still in bed?
  - - Todavía la quiero.
    - I still love her.
  :translation: still
```

# TODO

v1
  flashcards add es casi almost,nearly
  Full tests coverage including integration tests.
  Documentation.
  Tag (git) and publish the gem.

v11
  Add notes and tags (:swearwords, :dancing). Display notes after answer.
  flashcards add es xxx yyy #swearwords

v12
  Switch sides (ask in EN or in ES) (and deal with synonyms again).
    Change both translations and expression(s) to be either string or an array in the data,
    but always array after being parsed. If it's array with only one item, save as a string.
    (possibly use translation/translations keys)?

v13
  Tvary slov (primer, primero, primera; la (it); me, se, le), sloves.

v2
  Change to topics ?
  ~/.config/flashcards/es/base.yml
  ~/.config/flashcards/es/dancing.yml
  ~/.config/flashcards/es/ordinary_numbers.yml
