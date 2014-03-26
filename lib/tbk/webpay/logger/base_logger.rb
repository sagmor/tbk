module TBK
  module Webpay
    module Logger
      # This is an abstract class that defines the required interface of a Webpay logger
      class BaseLogger

        # Allow logger customization with a block
        def initialize(&block)
          block.call(self) if block
        end

        # Abstract method to log a payment
        def payment(payment)
          raise NotImplementedError, "TBK::Webpay::Logger::BaseLogger subclass must implement #payment method"
        end

        # Abstract method to log a payment confirmation
        def confirmation(confirmation)
          raise NotImplementedError, "TBK::Webpay::Logger::BaseLogger subclass must implement #confirmation method"
        end
      end
    end
  end
end
