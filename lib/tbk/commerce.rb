module TBK
  class Commerce
    attr_accessor :id
    attr_accessor :key

    def initialize(options)
      self.id = options[:id]

      raise TBK::CommerceError, "Missing commerce id" if self.id.nil?

      self.key = case options[:key]
      when String
        OpenSSL::PKey::RSA.new(options[:key])
      when OpenSSL::PKey::RSA.new
        options[:key]
      end

      raise TBK::CommerceError, "Missing commerce key" if self.key.nil?
      raise TBK::CommerceError, "Commerce key must be a RSA private key" unless self.key.private?
    end

    def test?
      false
    end

  end
end
