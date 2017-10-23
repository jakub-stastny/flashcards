require 'flashcards/core_exts'

module Flashcards
  class GenericCommand
    using CoreExts
    using RR::ColourExts
    using RR::StringExts # #titlecase

    class << self
      attr_accessor :help
      def main_command
        File.basename($0)
      end
    end

    def initialize(args)
      @args = args
    end

    # This is definitely not bullet-proof, (but at the moment it is sufficient for our needs).
    #
    # For instance: flashcards add de
    #
    # 1. Add to the German flashcards (de), incomplete arguments.
    # 2. Add to the default flashcards the word de (can be Spanish, from).
    def get_args(args)
      if args[0] && Flashcards.defined_languages.include?(args[0].to_sym)
        app = self.get_app_for_language(args[0])
        [app, args[1..-1]]
      else
        [Flashcards::App.new, args]
      end
    end

    def get_app_for_language(language)
      if Flashcards.defined_languages.include?(language.to_sym)
        Flashcards::App.new(language.to_sym)
      end
    end

    def get_app(language = nil)
      language ? self.get_app_for_language(language.to_sym) : Flashcards::App.new
    end
  end

  class SingleLanguageCommand < GenericCommand
    def app
      @app ||= Flashcards.app(@language_name)
    end
  end
end
