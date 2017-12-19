require 'flashcards'
require 'flashcards/core_exts'
require 'flashcards/testers/command_line'

# TODO: THIS IS ALREADY IN REFINED REFINEMENTS, DEPRECATE THIS VERSION.

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
        if command_class.help
          help = command_class.help.gsub(/\n/m, "\n  ")
          "#{buffer}  #{help}\n"
        else
          buffer
        end
      end.strip
    end

    def commands
      self.class.commands
    end

    def run(command_name, args)
      command_class = self.class.commands[command_name]
      command = command_class.new(args)
      command.run
    end

    require 'flashcards/commands/init'
    self.command(:init, InitCommand)

    require 'flashcards/commands/add'
    self.command(:+, AddCommand)

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

    require 'flashcards/commands/test'
    self.command(:test, TestCommand)

    require 'flashcards/commands/run'
    self.command(:run, RunCommand)
  end
end
