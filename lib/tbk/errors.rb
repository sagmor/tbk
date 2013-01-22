module TBK
  class Error < RuntimeError; end
  class CommerceError < Error; end

  module Webpay
    class PaymentError < Error; end
    class EncryptionError < Error; end
  end
end
