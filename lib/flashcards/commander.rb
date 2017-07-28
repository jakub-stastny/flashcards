require 'flashcards'
require 'flashcards/core_exts'
require 'flashcards/testers/command_line'

# TODO: Any command invocation should call auto_gc before to remove old backups.
module Flashcards
  class Commander
    def self.commands
      @commands ||= Hash.new
    end

    def self.command(command_name, command_class)
      self.commands[command_name] = command_class
    end

    def help_template
      <<-EOF
<red.bold>:: Flashcards ::</red.bold>

<cyan.bold>Commands</cyan.bold>
      EOF
    end

    def help
      self.commands.reduce(self.help_template) do |buffer, (command_name, command_class)|
        command_class.help ? buffer + command_class.help : buffer
      end
    end

    # This is definitely not bullet-proof, (but at the moment it is sufficient for our needs).
    #
    # For instance: flashcards add de
    #
    # 1. Add to the German flashcards (de), incomplete arguments.
    # 2. Add to the default flashcards the word de (can be Spanish, from).
    def get_args(args)
      if Flashcards.defined_languages.include?(args[0])
        self.set_language(args[0]) # This is a setter (maybe it shouldn't be and we should just return it?)
        args[1..-1]
      else
        args
      end
    end

    def set_language(language)
      if Flashcards.defined_languages.include?(language.to_sym)
        Flashcards.app(language) # This is a setter (maybe it shouldn't be and we should just return it?)
      end
    end

    def commands
      self.class.commands
    end

    def run(command_name, args)
      command_class = self.class.commands[command_name]
      command = command_class.new(app, args)
      command.run
    end

    require 'flashcards/commands/add'
    self.command(:add, AddCommand)

    require 'flashcards/commands/review'
    self.command(:review, ReviewCommand)

    require 'flashcards/commands/reset'
    self.command(:reset, ResetCommand)

    require 'flashcards/commands/stats'
    self.command(:stats, StatsCommand)

    require 'flashcards/commands/inspect'
    self.command(:inspect, InspectCommand)

    require 'flashcards/commands/verify'
    self.command(:verify, VerifyCommand)

    require 'flashcards/commands/console'
    self.command(:console, ConsoleCommand)

    require 'flashcards/commands/has-not-run-today'
    self.command(:'has-not-run-today', HasNotRunTodayCommand)

    require 'flashcards/commands/run'
    self.command(:run, RunCommand)
  end
end
