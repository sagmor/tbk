module TBK
  module Webpay
    module Encryption
      # Constants
      KEY_ID = 101
      KEY = TBK.parse_key('webpay.101')
      TEST_KEY = TBK.parse_key('webpay_test.101')
      IV_PADDING = "\x10\xBB\xFF\xBF\x00\x00\x00\x00\x00\x00\x00\x00\xF4\xBF"

      def webpay_key_id
        KEY_ID
      end

      def webpay_key
        self.production? ? KEY : TEST_KEY
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
        cipher.iv = iv + IV_PADDING
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
        cipher.iv = iv + IV_PADDING
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
