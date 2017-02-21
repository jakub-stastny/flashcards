# About

Flashcards for learning languages. Like [Anki](https://apps.ankiweb.net), but with an *actually* usable interface.

# Tutorial

First let's install the software and add a few flashcards. Let's say you're learning Spanish:

```shell
# Install it.
gem install flashcards

# Add data.
flashcards add todavía still
flashcards add casi almost,nearly
```

And run `flashcards`. Here you go!

![flashcards-1](https://raw.githubusercontent.com/botanicus/flashcards/master/doc/flashcards-1.png)

OK, it works. However it's important to learn in context, so let's make it more
useful and add some examples.

Run `flashcards edit` and paste the following data into the file:

```yaml
---
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

It's the same as there was, except of the added examples.

When you now re-run `flashcards`, you should get something more useful:

![flashcards-2](https://raw.githubusercontent.com/botanicus/flashcards/master/doc/flashcards-2.png)

As with any other flashcard software, flashcards is all about the [fancy learning curves](https://en.wikipedia.org/wiki/Spaced_repetition),
so you don't get tested over and over on vocabulary you already know (hello Duolingo!).

_The exact schedule is today, tomorrow, in 5 days and in 25 days._

Also if you add a lot of new vocabulary, won't test you on everything at once.
It will prioritise vocabulary that is time to refresh (according to spaced repetition),
and only adds limited number of the new vocabulary at a time.

Sometimes even spaced retention can fail, so flashcards will test you on vocabulary
you know once in a blue moon. We're talking months, not every other week, so chill ...

# Reference

## Support for packs

By default all the flashcards go into one file. Once you learn basic colours,
numbers and words like dog, cat, beer and fuck, it's probably time to start using
multiple flashcard files.

At this moment support for packs is rather simplist. Set environment variable `FF`
to point to any flashcard file.

```shell
export FF=~/.config/flashcards/es/swearwords.yml
flashcards add joder 'to fuck'
flashcards # Run it as usual.
```

Of course you can set it just for the current command by using
`FF=~/.config/flashcards/es/swearwords.yml flashcards`.

Despite its simplicity, this implementation has its advantages, for instance in
your `~/.zshrc` you can set `$FF` to a random pack or set it based on day of the week etc.

## Syntax of `~/.config/flashcards.yml`

The file `~/.config/flashcards.yml` is a hash saved in YAML.

The top-level keys are shortcuts of languages, such as `es` for Spanish, `pl` for Polish etc.

Each of these keys points to a list of flashcards.

## Flashcard keys

- Key `expression` (`string`, required): the word in the language you're learning.
- Key `translation` (`string`) or `translations` (`list` of `strings`): translation to English or whatever language you already know.
- Key `examples` (`list` of examples). Each example is a `list` of `[expression, translation]`.
- Key `hint`. _This is currently under review._
- Key `note` and `tags` will be added in v1.1, but as no key is deleted, you can use them already.
- Anything else will be saved.

```yaml
---
- :expression: todavía
  :translation: still
  :examples:
  - - "¿Todavía estás en la cama?"
    - Are you still in bed?
  - - Todavía la quiero.
    - I still love her.
```

## The `flashcard` command

Run `flashcard -h` to see all the options.

# Future features

- Testing the other side of cards.
- Support for different forms of words. Say "I speak" -> "hablo" (not "hablar" of course).
  Conjugation is the most obvious example, but it goes beyond verbs.
