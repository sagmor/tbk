require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Example
  class Application < Rails::Application

    TBK.configure do |config|
      config.environment :test
      config.commerce_id 597026007976
      # config.commerce_key SOME_RSA_KEY

      # Use official logger
      config.webpay_logger :official do |logger|
        logger.directory Rails.root.join('log/webpay')
      end
    end

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    config.secret_token = '0fd18b23f92f4ecee5516cf61cd564720731a67f125f5e4e808ef64c3016c9fc1a95dfa1f22a1e1511d2e26c98f9ade9097dbcf99ee2ddd4cdc5ccdbd6e3b5a3'
    config.session_store :cookie_store, key: '_example_session'
  end
end
