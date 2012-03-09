module Webpay
  module Config
    def self.timeout
      @timeout || 500
    end

    def self.timeout=(timeout)
      @timeout = timeout
    end
  end
end
