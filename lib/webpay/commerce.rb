module Webpay
  class Commerce
    def initialize(id, key)
      @id = id
      @key = OpenSSL::PKey::RSA.new(key)
    end

    def encrypt(text)
      Base64.encode(
        Webpay::Utils.chop(text,key_length-11).
          map{|block| @key.private_encrypt(block)}.
          join("")
      )
    end

    def decrypt(text)
      Webpay::Utils.chop(Base64.decode(text), key_length).
        map{|block| @key.private_decrypt(block) }.
        join("")
    end

    def id
      @id
    end

    def mac(text)
      digest = OpenSSL::Digest::MD5.new
      digest << text << @id.to_s << "webpay"
      digest.to_s
    end

    def payment(attributes)
      Payment.new(self,attributes)
    end

    def notification(params)
      Notification.new(self,params)
    end

    def test?
      @id == 597026016975
    end

    protected
      def key_length
        @key.public_key.params["n"].to_int.size
      end

    class << self
      def test
        self.new(597026016975, File.read(File.expand_path("../certification.pem", __FILE__)) )
      end
    end
  end
end
