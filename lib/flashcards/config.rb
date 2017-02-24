require 'yaml'
require 'ostruct'

# TODO: Keys symbols vs. strings.
module Flashcards
  class Config
    def config_path
      File.expand_path(ENV['FLASHCARDS_CONFIG'] || '~/.config/flashcards.yml')
    end

    def data
      @data ||= YAML.load_file(self.config_path)
    end

    def limit_per_run
      limit = @data.has_key?('limit_per_run') ? @data['limit_per_run'] : 25
      (limit == 0) ? false : limit
    end

    def schedule
      @data['schedule'] || [1, 5, 25, 125]
    end

    def language(language_name = nil)
      if language_name.nil? && data['learning'].keys.length == 1
        OpenStruct.new(data['learning'].values.first.merge(name: data['learning'].keys.first.to_sym))
      elsif language_name.nil? && (default_language = data['learning'].find { |_, lang| lang['default'] })
        OpenStruct.new(default_language[1].merge(name: default_language[0].to_sym))
      elsif language_name && data['learning'].keys.include?(language_name.to_s)
        OpenStruct.new(data['learning'][language_name.to_s].merge(name: language_name))
      elsif language_name && ! data['learning'].keys.include?(language_name.to_s)
        raise "Language #{language_name} is not configured. Your configured languages are: #{data['learning'].keys.inspect}"
      else
        raise "You have more than 1 language configured in your #{@path}: #{data['learning'].keys.inspect}. That means you have to specify which language you want to work with as the first argument."
      end
    end
  end
end
