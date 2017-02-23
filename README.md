# About ![](https://travis-ci.org/botanicus/flashcards.svg?branch=master)

Flashcards for learning languages. Like [Anki](https://apps.ankiweb.net), but with an *actually* usable interface and support for **conjugations**.

## Motivation

Learning a language is easier than most people think.

> Learning the first 1000 most frequently used words in the entire language will allow you to understand 76.0% of all non-fiction writing, 79.6% of all fiction writing, and an astounding 87.8% of all oral speech.
>
> Source: [HowLearnSpanish.com](http://howlearnspanish.com/2010/08/how-many-words-do-you-need-to-know/)

<span style="background-color: yellow">So all you have to do to be able to understand nearly 90% of spoken Spanish is to learn 10 Spanish words for 3 months and 10 days. Whaaat?</span>

Besides, if you're reading this, you're probably a programmer, right? I bet **you
know a bunch of languages already**. And no, I don't think it's all that different.
Figuring out with little knowledge based on context, learning bunch of words,
whether commands, methods or vocabulary, learning grammar ... what's the difference?
There's a reason why we call programming languages programming *languages*.

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

Also if you add a lot of new vocabulary, won't test you on everything at once.
It will prioritise vocabulary that is time to refresh (according to spaced repetition),
and only adds limited number of the new vocabulary at a time.

Sometimes even spaced retention can fail, so flashcards will test you on vocabulary
you know once in a blue moon. We're talking months, not every other week, so chill ...

# Day to day use

## Getting relevant vocabulary

Knowing every bloody ZOO animal ain't gonna help you to ask a hot Colombian for her number, right?

# Generic, relevant to you

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

# Future features

- Testing the other side of cards.
