# About [![](https://travis-ci.org/botanicus/flashcards.svg?branch=master)](https://travis-ci.org/botanicus/flashcards)

Flashcards for learning languages. Like [Anki](https://apps.ankiweb.net), but
with an *actually* usable interface and support for **conjugations** of regular
and irregular verbs.

![flashcards-screencash](https://raw.githubusercontent.com/botanicus/flashcards/master/doc/flashcards.gif)

## Motivation

There are many language learning apps out there. They are all missing one big thing and that is **context**. You will learn different vocabulary based on your objectives. Different Spanish is used in business, in daily situations, in books and in tango songs. Also there will be considerable differences in vocabulary (and also in pronunciation and even grammar) between different countries.

None of it the language apps take in consideration and this is why the only vocabulary that matters is the one you actually come in touch. Which means you need to write down words you come across and don't know and to learn them.

It is more work, but it's the only way I know to get results without wasting time learning vocabulary you don't need.

# Tutorial

First let's install the software and add a few flashcards. Let's say you're learning Spanish:

```shell
# Install it.
gem install flashcards

# Let's add Spanish into our languages.
flashcards init es

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
  - "¿Todavía estás en la cama?": "Are you still in bed?"
  - "Todavía la quiero.": "I still love her."
  :translation: still
- :expression: casi
  :translations:
  - almost
  - nearly
  :examples:
  - "Cuesta casi el doble.": "It costs almost twice as much."
  - "La casi totalidad de la población.": "Almost the entire population."
  - "Ya casi no tiene fiebre.": "She hardly has a temperature now."
```

It's the same as there was, except of the added examples.

When you now re-run `flashcards`, you should get something more useful:

![flashcards-2](https://raw.githubusercontent.com/botanicus/flashcards/master/doc/flashcards-2.png)

As with any other flashcard software, flashcards is all about the [fancy learning curves](https://en.wikipedia.org/wiki/Spaced_repetition),
so you don't get tested over and over on vocabulary you already know (hello Duolingo!).

_The exact schedule is next day, in five days, in 25 days, in 125 days and then every 2 years._

Also if you add a lot of new vocabulary, flashcards won't test you on everything at once.
It will prioritise vocabulary that is time to refresh (according to spaced repetition),
and only adds limited number of the new vocabulary at a time.

# Flashcards reference

## Conjugations

If a flashcard is tagged with `verb`, you will be automatically asked 1 random
conjugation of each tense. Currently only Spanish is supported, although adding
new rules is easy.

![flashcards-3](https://raw.githubusercontent.com/botanicus/flashcards/master/doc/flashcards-3.png)

## Syntax of `~/.config/flashcards.yml`

The file `~/.config/flashcards.yml` is an array of flashcards saved in YAML.

## Flashcard keys

- Key `expression` (`string`, required): the word in the language you're learning.
- Key `translation` (`string`) or `translations` (`list` of `strings`): translation to English or whatever language you already know. Note that for flashcard will parse `translation` if it's an array and `translations` if it's a string as well (and will format it correctly on save), so don't worry about it too much.
- Key `silent_translation` (`string`) or `silent_translations` (`list` of `strings`): same as the above, except these won't be listed as synonyms. When asked what veinte is, 20 is a valid answer. Or primer/primera/primero are all valid, but they are not synonyms, just different forms of the same word.
- Key `example` or `examples` (`list` of examples). Each example is a `key`: `value` pair of `[expression, translation]`.
- Key `hint`. _This is currently under review._
- Key `tag` (`symbol`) or `tags` (`list` of `symbols`). It can contain anything, currently flashcards support `:verb` tag to ask for conjugations. Only Spanish is supported at the moment, although adding new rules is easy, check out `lib/flashcards/verb.rb`.
- Key `note` (`string`). Note to be displayed after the word is answered. It's meant to mention irregular forms, differences from the translation (for instance to be can be either `ser` or `estar`, they are used differently, so the note would explain where to use which one).
- Anything else will be saved.

```yaml
---
- :expression: todavía
  :translation: still
  :examples:
  - "¿Todavía estás en la cama?": "Are you still in bed?"
  - "Todavía la quiero.": "I still love her."
```

## Day to day use

I have the following code in my `~/.zshrc`:

```
flashcards has-not-run-today && flashcards
```

It's pretty self-explanatory: if the flashcards hasn't run today, they will, once I open a new shell window. This way I learn every day without having to think about it.

## The `flashcard` command

Run `flashcard -h` to see all the options.

# Testimonials

> What is that? I see. Well, the colours are cool.
>
> ~ <cite>My mum.</cite>

> Why don't you get a real job like your grandpa? I don't know what this freelancing really is, but I don't think it's good for you!
>
> ~ <cite>My grandmother.</cite>

> Jesus Christ dude, you need to get laid!
>
> ~ <cite>My best friend.</cite>

> That's the shit pal!
>
> ~ <cite>Random homeless guy whom I paid money to review it.</cite>

As you can see, the credentials are bullet-proof.
