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
    FLASHCARD_FILE_PATH = '~/Dropbox/Data/Data/Flashcards/%lang%.yml'
    # "~/.config/flashcards/#{self.language_config.name}.yml",

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


    def flashcard_file
      Pathname.new(
        FLASHCARD_FILE_PATH.sub('%lang%', self.language_config.name.to_s)
      ).expand_path
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
      unless ENV['FLASHCARDS'] # Otherwise we save only the selected ones and discard all the rest.
        self.flashcard_file.open('w') { |file| file.puts(data.to_yaml) }
      end
    end

    protected
    def load_flashcards
      return Array.new if self.flashcard_file.nil?

      # YAML treats an empty string as false.
      flashcards = (YAML.load(self.flashcard_file.read) || Array.new).map do |flashcard_data|
        begin
          Flashcard.new(flashcard_data)
        rescue => error
          abort "Loading flashcard #{flashcard_data.inspect} failed: #{error.message}.\n\n#{error.backtrace}"
        end
      end

      if selected_flashcards_blob = ENV['FLASHCARDS']
        selected_flashcards = selected_flashcards_blob.split(/\s*,\s*/)
        flashcards.select do |flashcard|
          selected_flashcards.any? do |selected_flashcard|
            flashcard.expressions.include?(selected_flashcard)
          end
        end
      else
        flashcards
      end
    end
  end
end
