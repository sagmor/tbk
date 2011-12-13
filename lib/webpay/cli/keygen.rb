module Webpay
  module CLI
    class Keygen < Command
      Command.register self

      # Here I have to check if Webpay supports bigger keys.
      #   if it does, then I will increase this number
      DEFAULT_KEY_LENGTH = 1024
      DEFAULT_PATH_PREFIX = "./webpay"

      def setup(opts)
        opts.banner << "keygen [options]"

        opts.on("-l", "--length LENGTH", Integer, 
            "Bit length of the generated key.",
            "   Defaults to #{DEFAULT_KEY_LENGTH}") do |v|
          @options[:length] = v
        end

        opts.on("-o", "--output PATH",
            "Output file prefix.",
            "   Defaults to  #{DEFAULT_PATH_PREFIX}") do |v|
          @options[:output] = v
        end

      end

      def perform
        puts "Generating #{@options[:length] ||= DEFAULT_KEY_LENGTH} bits RSA key."
        key = OpenSSL::PKey::RSA.generate(
          @options[:length], 
          OpenSSL::BN.generate_prime(31)
        )
        puts "Key generated with id \"#{ key.hash.to_s }\""

        puts "Saving private key at #{@options[:output] ||= DEFAULT_PATH_PREFIX}.pem"
        File.open( File.expand_path("#{@options[:output]}.pem"), "w") do |file|
          file.write key.to_pem
        end

        puts "Saving public key at #{@options[:output] ||= DEFAULT_PATH_PREFIX}.pub"
        File.open( File.expand_path("#{@options[:output]}.pub"), "w") do |file|
          file.write key.public_key.to_pem
        end
      end
    end
  end
end
