module TBK
  class Commerce
    attr_accessor :id
    attr_accessor :key

    def initialize(options)
      @test = options[:test]

      self.id = options[:id]
      raise TBK::CommerceError, "Missing commerce id" if self.id.nil?

      self.key = case options[:key]
      when String
        OpenSSL::PKey::RSA.new(options[:key])
      when OpenSSL::PKey::RSA.new
        options[:key]
      when nil
        TBK::TEST_COMMERCE_KEY if self.test?
      end

      raise TBK::CommerceError, "Missing commerce key" if self.key.nil?
      raise TBK::CommerceError, "Commerce key must be a RSA private key" unless self.key.private?
    end

    def test?
      @test || false
    end

    def production?
      !self.test?
    end

    def key_bytes
      self.key.n.num_bytes
    end
  end
end
