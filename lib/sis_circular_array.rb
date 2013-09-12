require "sis_circular_array/version"
require_all 'lib'
require 'trollop'

module SisCircularArray
  class CLI

    USAGE_MESSAGE = <<-HERE
      SiSCircularArray takes two different sets of arguments, one for R and one for C. 
      Specify R -h or C -h to get help for each command.
    HERE
    SUB_COMMANDS = %w{R C}
    R_MESSAGE =  <<-HERE
 R <s> <demand.dat> [options]
          s:   An integer that specifies the level at which an order will be placed
 demand.dat:   A file with something something something
          HERE
    C_MESSAGE = <<-HERE
 C <s> <demand.dat> <index> [options]
           s:   An integer that specifies the level at which an order will be placed
  demand.dat:   A file with something something something
       index:   Specifies something
          HERE

    def initialize

      global_opts = Trollop::options do
        banner USAGE_MESSAGE
        version "SisCircularArray 0.1.0 (c) Tyler Thrailkill 2013"
        opt :verbose, "Outputs debugging details for all classes to STDOUT. If false, it will output to log files.", :short => :v
        stop_on SUB_COMMANDS
      end

      cmd = ARGV.shift # get the subcommand
      cmd_opts = case cmd
      when "R" # parse A options
        Trollop::options do 
          banner R_MESSAGE
        end
        Trollop::die "Wrong number of Arguments for Capital R" if ARGV.length != 2
        Trollop::die "<s> needs to be an integer" if not ARGV[0].is_i?
        Trollop::die "<demand.dat> needs to be a filename in the current directory" if not File.file?(ARGV[1])
        @s = ARGV.shift.to_i
        @file = ARGV.shift
      when "C"  # parse B options
        Trollop::options do 
          banner C_MESSAGE
        end
        Trollop::die "Wrong number of Arguments for Capital C" if ARGV.length != 3
        Trollop::die "<s> need to be an integer " if not ARGV[0].is_i?
        Trollop::die "<demand.dat> needs to be a filename in the current directory" if not File.file?(ARGV[1])
        Trollop::die "<index> need to be an integer" if not ARGV[2].is_i?
        @s = ARGV.shift.to_i
        @file = ARGV.shift
        @index = ARGV.shift.to_i
      else
        Trollop::die "unknown subcommand #{cmd.inspect}"
      end
      
      
    end
  end

end

class String
  def is_i?
     !!(self =~ /^[-+]?[0-9]+$/)
  end
end
