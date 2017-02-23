require 'yaml'
require 'ostruct'

module Flashcards
  def self.config_path
    File.expand_path('~/.config/flashcards.yml')
  end

  def self.config
    @config ||= Config.new(self.config_path)
  end

  class Config
    def initialize(path)
      @path = path
    end

    def data
      @data ||= YAML.load_file(@path)
    end

    # {"learning"=>{"es"=>["present", "past", "reflective"]}}
    def language(language_name = nil)
      if language_name.nil? && data['learning'].keys.length == 1
        data['learning'].keys.first.to_sym
        OpenStruct.new(
          name: data['learning'].keys.first.to_sym,
          tested_forms: data['learning'].values.first)
      elsif language_name && data['learning'].keys.include?(language_name.to_s)
        OpenStruct.new(name: language_name,
          tested_forms: data['learning'][language_name.to_s])
      elsif language_name && ! data['learning'].keys.include?(language_name.to_s)
        raise "Language #{language_name} is not configured. Your configured languages are: #{data['learning'].keys.inspect}"
      else
        raise "You have more than 1 language configured in your #{@path}: #{data['learning'].keys.inspect}. That means you have to specify which language you want to work with as the first argument."
      end
    end
  end
end
