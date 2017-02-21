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

_The exact schedule is next day, in five days, in 25 days, in 125 days and then every 2 years._

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
# Assuming the directory ~/.config/flashcards/es exists:
export FF=~/.config/flashcards/es/swearwords.yml

flashcards add joder 'to fuck'
flashcards # Run it as usual.
```

Of course you can set it just for the current command by using
`FF=~/.config/flashcards/es/swearwords.yml flashcards`.

Despite its simplicity, this implementation has its advantages, for instance in
your `~/.zshrc` you can set `$FF` to a random pack or set it based on day of the week etc.

## Conjugations

If a flashcard is tagged with `verb`, you will be automatically asked 1 random
conjugation of each tense. Currently only Spanish is supported, although adding
new rules is easy, check out `lib/flashcards/verb.rb`. Bonus points for sending a PR.

Irregular verbs are not yet supported, although it's just a matter of adding few rules.
You can tag them with `irregular` and deal with them later. They will be skipped for now.

![flashcards-3](https://raw.githubusercontent.com/botanicus/flashcards/master/doc/flashcards-3.png)

## Syntax of `~/.config/flashcards.yml`

The file `~/.config/flashcards.yml` is an array of flashcards saved in YAML.

## Flashcard keys

- Key `expression` (`string`, required): the word in the language you're learning.
- Key `translation` (`string`) or `translations` (`list` of `strings`): translation to English or whatever language you already know.
- Key `examples` (`list` of examples). Each example is a `list` of `[expression, translation]`.
- Key `hint`. _This is currently under review._
- Key `tags` (`list` of `symbols`). It can contain anything, currently flashcards support `:verb` tag to ask for conjugations. Only Spanish is supported at the moment, although adding new rules is easy, check out `lib/flashcards/verb.rb`.
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
