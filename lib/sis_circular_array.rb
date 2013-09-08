require "sis_circular_array/version"

module SisCircularArray
  class CLI < Trollop

    USAGE_MESSAGE = <<-HERE
      A usage message
    HERE

    def initialize

      global_opts = Trollop::options do
        banner USAGE_MESSAGE
        version "SisCircularArray 0.1.0 (c) Tyler Thrailkill 2013"
        opt :verbose, "Outputs debugging details for all classes to STDOUT. If false, it will output to log files.", :short => :v
        stop_on SUB_COMMANDS
      end
      
      
      # Trollop::die USAGE_MESSAGE if not @seed.is_a? Integer # Something is wrong with this
      
      # Trollop::Parser.new do
      # end

      cmd = ARGV.shift # get the subcommand
      cmd_opts = case cmd
      when "R" # parse A options
        Trollop::die "Wrong number of Arguments for Capital R" if ARGV.length != 2
        Trollop::die "<s> needs to be an integer" if not ARGV[0].is_a? Integer
        Trollop::die "<demand.dat> needs to be a filename in the current directory" if not ARGV[1] and not File.file?(ARGV[2])
        @runs = ARGV.shift.to_i
        @number_of_players = ARGV.shift.to_i
      when "C"  # parse B options
        Trollop::die "Wrong number of Arguments for Capital C" if ARGV.length != 3
      else
        Trollop::die "unknown subcommand #{cmd.inspect}"
      end
      
    end
  end
end
