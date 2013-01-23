module TBK
  class Error < StandardError
    attr_reader :origin
    def initialize(msg, origin=nil)
      super(msg)
      @origin = origin
    end
  end

  class CommerceError < Error; end

  module Webpay
    class PaymentError < Error; end
    class EncryptionError < Error; end
  end
end
