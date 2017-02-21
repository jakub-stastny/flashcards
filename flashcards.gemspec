#!/usr/bin/env gem build

Gem::Specification.new do |s|
  s.name        = 'flashcards'
  s.version     = '0.0.1'
  s.authors     = ['James C Russell']
  s.email       = 'james@101ideas.cz'
  s.homepage    = 'http://github.com/botanicus/flashcards'
  s.summary     = 'Simple flashcards for learning languages'
  s.description = '...'
  s.license     = 'MIT'

  s.files       = Dir.glob('{bin,lib}/**/*.rb') + ['README.md']
  s.executables = Dir['bin/*'].map(&File.method(:basename))

  s.add_runtime_dependency('term-ansicolor', ['~> 1.4'])
end
