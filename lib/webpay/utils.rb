module Webpay
  module Utils
    def self.chop(string,length)
      string.unpack( "a#{length}" * (string.length.to_f/length).ceil )
    end
  end
end

