module Webpay
  class Commerce
    WEBPAY_HOST = "https://webpay.transbank.cl:443"
    WEBPAY_TEST_HOST = "https://certificacion.webpay.cl:6443"

    def initialize(options)
      @id = options[:id]
      @key = OpenSSL::PKey::RSA.new(options[:key])
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

    def webpay_host
      test? ? WEBPAY_TEST_HOST : WEBPAY_HOST
    end

    def redirect_url_for(token)
      "#{ @commerce.webpay_host }#{Payment::PROCESS_PATH}?TBK_VERSION_KCC=5.1&TBK_TOKEN=#{token}"
    end

    protected
      def key_length
        @key.public_key.params["n"].to_int.size
      end

    class << self
      def test
        self.new({
          :id => 597026016975,
          :key => File.read(File.expand_path("../test.pem", __FILE__))
        })
      end
    end
  end
end
