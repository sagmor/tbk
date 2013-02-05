module TBK
  class Config

    # Set and gets the default commerce id
    def commerce_id(id = nil)
      @id = id if id
      @id || ENV['TBK_COMMERCE_ID']
    end

    # Sets and gets the default commerce key
    def commerce_key(key = nil)
      @key = key if key
      @key || ENV['TBK_COMMERCE_KEY']
    end

    # Set and gets the default IP address of the confirmation URL
    def confirmation_url_ip_address(ip_address = nil)
      @ip_address = ip_address if ip_address
      @ip_address || ENV['TBK_CONFIRMATION_URL_IP_ADDRESS']
    end

    # Set and gets the default port of the confirmation URL
    def confirmation_url_port(port = nil)
      @port = port if port
      @port || ENV['TBK_CONFIRMATION_URL_PORT']
    end

    # Set and gets the default protocol for the confirmation URL
    def confirmation_url_protocol(protocol = nil)
      @protocol = protocol if protocol
      @protocol || ENV['TBK_CONFIRMATION_URL_PROTOCOL']
    end

    # Sets the default commerce environment
    # @return [Symbol] the default commerce environment
    def environment(environment = nil)
      @environment = environment if environment
      (@environment || ENV['TBK_COMMERCE_ENVIRONMENT'] || :production.to_sym)
    end
  end

  # Returns the configuration object
  # @return [TBK::Config] the configuration object
  def self.config
    @config ||= Config.new
  end

  # Configure the app defaults simply by doing
  #
  #     TBK.configure do |config|
  #       config.commerce_id 123456
  #       config.commerce_key File.read(COMMERCE_KEY_PATH)
  #     end
  #
  # @yield [TBK::Config] The config object
  def self.configure(&block)
    yield(self.config)
    nil
  end

end