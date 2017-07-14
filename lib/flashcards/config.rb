require 'yaml'
require 'ostruct'

# TODO: Keys symbols vs. strings.
module Flashcards
  class Config
    attr_reader :config_path
    def initialize(config_path = default_config_path)
      @config_path = config_path
    end

    def data
      @data ||= YAML.load_file(self.config_path)
    end

    def limit_per_run
      limit = self.data.has_key?('limit_per_run') ? self.data['limit_per_run'] : 25
      (limit == 0) ? false : limit
    end

    def schedule
      self.data['schedule'] || [1, 5, 25, 125]
    end

    def language(language_name = nil)
      if language_name.nil? && data['learning'].keys.length == 1
        OpenStruct.new(data['learning'].values.first.merge(name: data['learning'].keys.first.to_sym))
      elsif language_name.nil? && (default_language = data['learning'].find { |_, lang| lang['default'] })
        OpenStruct.new(default_language[1].merge(name: default_language[0].to_sym))
      elsif language_name #&& data['learning'].keys.include?(language_name.to_s)
        config = data['learning'][language_name.to_s] || Hash.new
        OpenStruct.new(config.merge(name: language_name))
      # elsif language_name && ! data['learning'].keys.include?(language_name.to_s)
      #   raise "Language #{language_name} is not configured. Your configured languages are: #{data['learning'].keys.inspect}"
      else
        raise "You have more than 1 language configured in your #{@path}: #{data['learning'].keys.inspect}. That means you have to specify which language you want to work with as the first argument."
      end
    end

    def should_be_tested_on?(tense)
      self.language.test_me_on.nil? ||
      self.language.test_me_on.include?(tense)
    end

    private
    def default_config_path
      File.expand_path(ENV['FLASHCARDS_CONFIG'] || '~/.config/flashcards.yml')
    end
  end
end
