#!/usr/bin/env gem build

Gem::Specification.new do |s|
  s.name        = 'flashcards'
  s.version     = '0.0.2'
  s.authors     = ['James C Russell']
  s.email       = 'james@101ideas.cz'
  s.homepage    = 'http://github.com/botanicus/flashcards'
  s.summary     = 'Simple flashcards for learning languages.'
  s.description = "#{s.summary}. Supports conjugations of regular and irregular verbs."
  s.license     = 'MIT'

  s.files       = Dir.glob('{bin,lib}/**/*.rb') + ['README.md']
  s.executables = Dir['bin/*'].map(&File.method(:basename))

  s.add_runtime_dependency('term-ansicolor', ['~> 1.4'])
  s.add_runtime_dependency('refined-refinements', ['~> 0.0'])

  s.post_install_message = <<-EOF
Welcome to flashcards! To start, run

  flashcards init es # Spanish. Use any two character long language code.

Use the help to learn more (flashcards -h).

The full manual is available at http://github.com/botanicus/flashcards
  EOF
end
