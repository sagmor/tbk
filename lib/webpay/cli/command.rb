module Webpay
  module CLI
    class Command
      @commands = Hash.new(self)

      def self.register(klass)
        @commands[klass.to_s.downcase.gsub("webpay::cli::","")] = klass
      end

      def self.commands
        @commands.keys
      end

      def self.load(args)
        @commands[ args.first ].new(args[1..-1])
      end

      def initialize(args)
        @args = args || []
        @options = {}

        OptionParser.new do |opts|
          opts.banner = "USAGE #{$0} "
          opts.define_head "\nCommand Options" unless self.class == Command

          setup(opts)

          opts.define_tail "\nGlobal Options"

          opts.on_tail("-v", "--verbose", "Run verbosely") do |v|
            @options[:verbose] = v
          end

          opts.on_tail("-h", "--help", "Show usage help") do |v|
            @options[:help] = v
          end

          @usage = opts.help()

        end.parse! @args
      end

      def setup(opts)
        opts.banner << "command [options]" +
                      "\n  Available commands: #{Command.commands.join(" ")}" +
                      "\n  For help use #{$0} command --help"
      end

      def run
        if @options[:help]
          puts usage
          exit 0
        end

        perform
        exit 0
      end

      def perform
        puts "Command not found"
        puts usage
        exit 1
      end

      def usage
        @usage
      end
    end
  end
end

