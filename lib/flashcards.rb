require 'flashcards/flashcard'
require 'flashcards/test'
require 'flashcards/language'
require 'flashcards/config'
require 'flashcards/core_exts'
require 'flashcards/collection'

module Flashcards
  def self.app(language_name = nil)
    language_name ? @app = App.new(language_name) : @app ||= App.new
  end

  def self.defined_languages
    Dir.glob("#{Collection.data_file_dir}/*.yml").map { |path| File.basename(path).split('.').first.to_sym }.uniq
  end

  class App
    using CoreExts
    using RR::ColourExts

    def initialize(language_name = nil)
      @language_name = language_name.to_sym if language_name
    end

    def config
      @config ||= Config.new
    end

    def language_config
      self.config.language(@language_name)
    end

    def language
      require "flashcards/languages/#{self.language_config.name}"
      self.languages[self.language_config.name] || raise(
        "Language #{self.language_config.name} has a definition file, but it's empty.")
    rescue LoadError # Unsupported language.
      Language.new(self.language_config.name, self.config)
    end

    def languages
      @languages ||= Hash.new
    end

    def define_language(name, &block)
      self.languages[name] ||= Language.new(name, self.language_config)
      self.languages[name].instance_eval(&block)
    end

    def flashcards
      collection = Flashcards::Collection.new(Flashcard, self.language.name.to_s)
      collection.filter(:env) do |flashcard|
        ENV['FLASHCARDS'].nil? || ENV['FLASHCARDS'].split(/,\s*/).any? do |expression|
          flashcard.expressions.include?(expression)
        end
      end
    end

    def tests
      basename = "#{self.language.name.to_s}.tests"
      Flashcards::Collection.new(Test, basename)
    end
  end
end
