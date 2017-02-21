# About

Flashcards for learning languages. Like [Anki](https://apps.ankiweb.net), but with an *actually* usable interface.

## Tutorial

First we have to add a few flashcards. Let's say you're learning Spanish.

```shell
# Install it.
gem install flashcards

# Add data.
flashcards add es todavía still
flashcards add es casi almost,nearly
```

And run `flashcards`. Here you go!

![flashcards-1](https://raw.githubusercontent.com/botanicus/flashcards/master/doc/flashcards-1.png)

This is just the basics though. It's important to learn in context, so let's
make it more useful and add some examples.

Run `flashcards edit` and paste the following data into the file:

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
- :expression: casi
  :translations:
  - almost
  - nearly
  :examples:
  - - Cuesta casi el doble.
    - It costs almost twice as much.
  - - La casi totalidad de la población.
    - Almost the entire population.
  - - Ya casi no tiene fiebre.
    - She hardly has a temperature now.
```

When you re-run `flashcards`, you should get something more useful:

![flashcards-2](https://raw.githubusercontent.com/botanicus/flashcards/master/doc/flashcards-2.png)

As with any other flashcard software, flashcards is all about the [fancy learning curves](https://en.wikipedia.org/wiki/Spaced_repetition),
so you don't get tested over and over on vocabulary you already know (hello Duolingo!).

Also if you add a lot of new vocabulary, flashcards will test you on it, but
in the subsequent runs it will rather test you on something that's time to refresh
(say you answered it correctly yesterday and now it's time for repetition) than
to test you on a completely new word and let you forget the other one in the meantime.

Sometimes even spaced retention can fail, so flashcards will test you on vocabulary
you know once in a blue moon. We're talking months, not every other week, so chill ..

## Syntax of `~/.config/flashcards.yml`

The file `~/.config/flashcards.yml` is a hash saved in YAML.

The top-level keys are shortcuts of languages, such as `es` for Spanish, `pl` for Polish etc.

Each of these keys points to a list of flashcards.

### Flashcard keys

- Key `expression` (`string`, required): desc.
- Key `translation` (`string`) or `translations` (`list` of `strings`): desc.
- Key `examples` (`list` of examples, each example is another list of 2 items - example text, example translation).
- Key `hint`
- Key `note` and `tags` will be added in v1.1, but as no key is deleted, you can use them already.
- Anything else will be saved.

```yaml
---
es:
- :expression: todavía
  :translation: still
  :examples:
  - - "¿Todavía estás en la cama?"
    - Are you still in bed?
  - - Todavía la quiero.
    - I still love her.
```

# Future features

- Testing the other side of the card.
- Support for different forms of words. Say "I speak" -> "hablo" (not "hablar" of course).
  Conjugation is the most obvious example, but it goes beyond verbs.
