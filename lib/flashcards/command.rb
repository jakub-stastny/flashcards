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
  end

  class SingleLanguageCommand < GenericCommand
    def app
      @app ||= Flashcards.app(@language_name)
    end
  end
end
