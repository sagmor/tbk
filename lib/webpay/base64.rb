require 'base64'

module Webpay
  module Base64
    REPLACEMENTS = ["+/=", "-._"]

    def self.encode(text)
      Webpay::Utils.chop( [text].pack("m0").tr(*REPLACEMENTS), 64 ).join("\n") + "\n"
    end

    def self.decode(text)
      ::Base64.decode64( text.tr(*REPLACEMENTS.reverse) )
    end
  end
end

