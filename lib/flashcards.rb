require 'flashcards/flashcard'
require 'flashcards/test'
require 'flashcards/language'
require 'flashcards/config'
require 'flashcards/core_exts'

module Flashcards
  def self.app(language_name = nil)
    @app ||= App.new(language_name)
  end

  class App
    using CoreExts
    using RR::ColourExts

    def initialize(language_name = nil)
      @language_name = language_name
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

    def load(&block)
      flashcards = Flashcards::Flashcard.load(self.language.name.to_s)
      flashcards = filter_selected_flashcards(flashcards) if ENV['FLASHCARDS']
      block.call(flashcards)
    end

    def load_do_then_save(&block)
      flashcards = Flashcards::Flashcard.load(self.language.name.to_s)
      flashcards = filter_selected_flashcards(flashcards) if ENV['FLASHCARDS']
      data = block.call(flashcards)
      unless ENV['FLASHCARDS'] # Otherwise we save only the selected ones and discard all the rest.
        Flashcards::Flashcard.save(self.language.name.to_s, data)
      end
    end

    protected
    def filter_selected_flashcards(flashcards)
      selected_flashcards = ENV['FLASHCARDS'].split(/\s*,\s*/)
      puts "<blue.bold>~</blue.bold> <green>Applying filter #{selected_flashcards.map { |selected_flashcard| "<yellow>#{selected_flashcard}</yellow>" }.join_with_and}.</green>".colourise
      flashcards.select do |flashcard|
        selected_flashcards.any? do |selected_flashcard|
          flashcard.expressions.include?(selected_flashcard)
        end
      end
    end
  end
end
