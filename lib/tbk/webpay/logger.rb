require "tbk/webpay/logger/base_logger"
module TBK
  module Webpay

    # Get the logger class for a given Symbol
    def self.logger_for_symbol(sym)
      logger_class_name = "#{sym.to_s.gsub(/(^\w)|(_\w)/){ |s| s.upcase[-1] }}Logger"
      logger_require_path = "tbk/webpay/logger/#{sym}_logger"

      require logger_require_path

      TBK::Webpay::Logger.const_get(logger_class_name)
    end

    def self.logger(logger=nil, &block)
      if logger
        klass = case logger
                when Symbol
                  self.logger_for_symbol(logger)
                when Class
                  logger
                else
                  raise ArgumentError, "first argument must be a Symbol or a Class"
                end

        @logger = klass.new(&block)
      end

      @logger
    end
    self.logger(:null)
  end
end
