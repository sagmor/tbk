module TBK
  module Webpay
    module Logger
      class NullLogger < BaseLogger
        def payment(payment)
          # NoOp
        end

        def confirmation(confirmation, accept)
          # NoOp
        end
      end
    end
  end
end
