module Webpay
  module Utils
    def self.chop(string,length)
      string.unpack( "a#{length}" * (string.length.to_f/length).ceil )
    end

    # Taken from http://coderrr.wordpress.com/2008/05/28/get-your-local-ip-address/
    def self.local_ip
      @local_ip ||= begin
        # turn off reverse DNS resolution temporarily
        orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
       
        UDPSocket.open do |s|
          s.connect '64.233.187.99', 1
          s.addr.last
        end
      ensure
        Socket.do_not_reverse_lookup = orig
      end
    end

  end
end

