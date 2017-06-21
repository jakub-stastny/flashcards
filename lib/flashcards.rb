require 'yaml'
require 'pathname'
require 'flashcards/flashcard'
require 'flashcards/language'
require 'flashcards/config'

module Flashcards
  def self.app(language_name = nil)
    @app ||= App.new(language_name)
  end

  class App
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
      self.languages[self.language_config.name]
    rescue LoadError # Unsupported language.
      Language.new
    end

    def languages
      @languages ||= Hash.new
    end

    def define_language(name, &block)
      self.languages[name] ||= Language.new(name, self.language_config)
      self.languages[name].instance_eval(&block)
    end

    def flashcard_file
      @flashcard_file ||= [
        "~/.config/flashcards/#{self.language_config.name}.yml",
        "~/Dropbox/Data/Data/Flashcards/#{self.language_config.name}.yml"
      ].map { |path| Pathname.new(path).expand_path }.find { |path| path.exist? }
    end

    def flashcards
      @flashcards ||= load_flashcards
    rescue Errno::ENOENT
      Array.new
    end

    def _load(&block)
      block.call(self.flashcards)
    end

    def load_do_then_save(&block)
      data = block.call(self.flashcards)
      self.flashcard_file.open('w') { |file| file.puts(data.to_yaml) }
    end

    protected
    def load_flashcards
      # YAML treats an empty string as false.
      (YAML.load(self.flashcard_file.read) || Array.new).map do |flashcard_data|
        begin
          Flashcard.new(flashcard_data)
        rescue => error
          abort "Loading flashcard #{flashcard_data.inspect} failed: #{error.message}.\n\n#{error.backtrace}"
        end
      end
    end
  end
end
