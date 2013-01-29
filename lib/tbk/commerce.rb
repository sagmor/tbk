
module TBK
  # Represents a commerce registered with Transbank
  class Commerce

    # The registered commerce id
    # @return [Integer] the commerce id
    attr_reader :id

    # The commerce secret RSA key
    # @return [OpenSSL::PKey::RSA] the commerce key
    attr_reader :key

    # The commerce environment
     # @return [Symbol] the commerce environment
    attr_reader :environment

    # Initializes a new commerce
    # @param [Hash] attributes The commerce attributes
    # @option attributes [Integer] :id The commerce ID
    # @option attributes [String|OpenSSL::PKey::RSA] :key The commerce RSA private key
    # @option attributes [Boolean] :test flag to set commerce in test mode
    def initialize(attributes)
      @environment = (attributes[:environment] || :production).to_sym
      raise TBK::CommerceError, "Invalid commerce environment" unless [:production,:test].include? @environment

      @id = attributes[:id]
      raise TBK::CommerceError, "Missing commerce id" if self.id.nil?

      @key = case attributes[:key]
      when String
        OpenSSL::PKey::RSA.new(attributes[:key])
      when OpenSSL::PKey::RSA.new
        attributes[:key]
      when nil
        TEST_COMMERCE_KEY if self.test?
      end

      raise TBK::CommerceError, "Missing commerce key" if self.key.nil?
      raise TBK::CommerceError, "Commerce key must be a RSA private key" unless self.key.private?
    end

    # @return [Boolean] whether or not the commerce is in test mode
    def test?
      self.environment == :test
    end

    # @return [Boolean] whether or not the commerce is in production mode
    def production?
      self.environment == :production
    end

    # @return [Integer] RSA key bytes
    def key_bytes
      self.key.n.num_bytes
    end

    # @return [TBK::Commerce] The default commerce
    def self.default_commerce
      @default_commerce ||= Commerce.new({
        :id => TBK.config.commerce_id,
        :key => TBK.config.commerce_key,
        :environment => TBK.config.environment
      }) unless TBK.config.commerce_id.nil?
    end

    TEST_COMMERCE_KEY = TBK.parse_key('test_commerce')
  end
end
