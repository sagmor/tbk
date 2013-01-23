module TBK
  module Webpay
    module Encryption
      IV_PADDING = "\x10\xBB\xFF\xBF\x00\x00\x00\x00\x00\x00\x00\x00\xF4\xBF"

      KEY_ID = 101
      KEY = OpenSSL::PKey::RSA.new <<-EOK
      -----BEGIN PUBLIC KEY-----
      MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxKKjroxE7X44TQovh9A9
      ZpntP7LrdoyFsnJbDKjOOCoiid92FydN5qemyQCeXhsc7QHUXwGdth22fB8xJr3a
      MZBEUJ+BKFrL+W6yE5V+F5Bj0Uq3lL0QMAIftGhLpgqw0ZMtU89kyd9Q4Rclq4r8
      p2m/ZD7Pn5EmTOFSeyoWTMZQDl7OEoCKh/cZH5NJdWL08lCI+sGLOghRmFzkve4h
      F9JCwKA7NYG7j3BWh39Oj2NIXEY/TO1Y3Y2WfNv9nvTpr46SpFlyp0KOhSiqgvXX
      DgeXlebyqS82ch2DzOV9fjDAw7t71WXJBAev8Gd6HXwIXE/JP6AnLCa2Y+b6Wv8K
      GWBCMIBXWL0m7WHeCaJ9Hx2yXZmHJh8FgeKffFKCwn3X90JiMocOSGsOE+Sfo85S
      h/39Vc7vZS3i7kJDDoz9ab9/vFy30RuJf4p8Erh7kWtERVoG6/EhR+j4N3mgIOBZ
      SHfzDAoOnqP5l7t2RXYcEbRLVN6o+XgUtalX33EJxJRsXoz9a6PxYlesIwPbKteD
      BZ/xyJDwTc2gU2YzSH8G9anKrcvITBDULSAuxQUkYOiLbkb7vSKWDYKe0do6ibO3
      RY/KXI63Q7bGKYaI2aa/8GnqVJ2G1U2s59NpqX0aaWjn59gsA8trA0YKOZP4xJIh
      CvLM94G4V7lxe2IHKPqLscMCAwEAAQ==
      -----END PUBLIC KEY-----
      EOK

      TEST_KEY = OpenSSL::PKey::RSA.new <<-EOK
      -----BEGIN PUBLIC KEY-----
      MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtKe3HHWwRcizAfkbS92V
      fQr8cUb94TRjQPzNTqBduvvj65AD5J98Cn1htE3NzOz+PjPRcnfVe53V4f3+YlIb
      6nnxyeuYLByiwoPkCmpOFBxNp04/Yh3dxN4xgOANXA37rNbDeO4WIEMG6zbdQMNJ
      7RqQUlJSmui8gt3YxtqWBhBVW79qDCYVzxFrv3SH7pRuYEr+cxDvzRylxnJgr6ee
      N7gmjoSMqF16f9aGdQ12obzV0A35BqpN6pRFoS/NvICbEeedS9g5gyUHf54a+juB
      OV2HH5VJsCCgcb7I7Sio/xXTyP+QjIGJfpukkE8F+ohwRiChZ9jMXofPtuZYZiFQ
      /gX08s5Qdpaph65UINP7crYbzpVJdrT2J0etyMcZbEanEkoX8YakLEBpPhyyR7mC
      73fWd9sTuBEkG6kzCuG2JAyo6V8eyISnlKDEVd+/6G/Zpb5cUdBCERTYz5gvNoZN
      zkuq4isiXh5MOLGs91H8ermuhdQe/lqvXf8Op/EYrAuxcdrZK0orI4LbPdUrC0Jc
      Fl02qgXRrSpXo72anOlFc9P0blD4CMevW2+1wvIPA0DaJPsTnwBWOUqcfa7GAFH5
      KGs3zCiZ5YTLDlnaps8koSssTVRi7LVT8HhiC5mjBklxmZjBv6ckgQeFWgp18kuU
      ve5Elj5HSV7x2PCz8RKB4XcCAwEAAQ==
      -----END PUBLIC KEY-----
      EOK

      def webpay_key_id
        TBK::Webpay::Ecryption::KEY_ID
      end

      def webpay_key
        self.production? ? TBK::Webpay::Ecryption::KEY : TBK::Webpay::Ecryption::TEST_KEY
      end

      def webpay_key_length
        webpay_key.n.num_bytes
      end

      def webpay_encrypt(text)
        signature = self.key.sign(OpenSSL::Digest::SHA512.new, text)

        key = SecureRandom.random_bytes(32)
        encripted_key = webpay_key.public_encrypt(key, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)

        iv = SecureRandom.random_bytes(16)

        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.encrypt
        cipher.key = key
        cipher.iv = iv + TBK::Webpay::Ecryption::IV_PADDING
        encripted_text = cipher.update(signature + text) + cipher.final

        Base64.encode64( iv + encripted_key + encripted_text).strip
      rescue RuntimeError => error
        raise TBK::Webpay::EncryptionError, "Encryption failed", error
      end

      def webpay_decrypt(encripted_text)
        data = Base64.decode64(encripted_text)

        iv = data[0...16]
        encripted_key = data[16...(16 + self.key_bytes)]
        key = self.key.private_decrypt(encripted_key, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)

        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.decrypt
        cipher.key = key
        cipher.iv = iv + TBK::Webpay::Ecryption::IV_PADDING
        decrypted_text = cipher.update(data[(16 + self.key_bytes)..-1]) + cipher.final
        signature = decrypted_text[0...(webpay_key_length)]
        text = decrypted_text[(webpay_key_length)..-1]

        unless webpay_key.verify(OpenSSL::Digest::SHA512.new, signature, text)
          raise TBK::Webpay::EncryptionError, "Invalid message signature"
        end

        text
      rescue => error
        raise TBK::Webpay::EncryptionError, "Decryption failed", error
      end
    end
  end

  Commerce.send :include, Webpay::Encryption
end