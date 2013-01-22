module TBK
  module Webpay
    module Encryption
      IV_PADDING = "\x10\xBB\xFF\xBF\x00\x00\x00\x00\x00\x00\x00\x00\xF4\xBF"

      def webpay_encrypt(text)
        signature = self.key.sign(OpenSSL::Digest::SHA512.new, text)

        key = SecureRandom.random_bytes(32)
        encripted_key = TBK::KEY.public_encrypt(key, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)

        iv = SecureRandom.random_bytes(16)

        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.encrypt
        cipher.key = key
        cipher.iv = iv + IV_PADDING
        encripted_text = cipher.update(signature + text) + cipher.final

        Base64.encode64( iv + encripted_key + encripted_text).strip
      end

      def webpay_decrypt(encripted_text)
        data = Base64.decode64(encripted_text)

        iv = data[0...16]
        encripted_key = data[16...(16 + TBK::KEY.n.num_bytes/4 )]
        key = self.key.private_decrypt(encripted_key, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)

        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.decrypt
        cipher.key = key
        cipher.iv = iv + IV_PADDING
        decrypted_text = cipher.update(data[(16 + TBK::KEY_LENGTH/4 )..-1]) + cipher.final
        signature = decrypted_text[0...(TBK::KEY_LENGTH)]
        text = decrypted_text[(TBK::KEY_LENGTH)..-1]

        unless TBK::KEY.verify(OpenSSL::Digest::SHA512.new, signature, text)
          raise TBK::Webpay::EncryptionError, "Invalid message signature"
        end

        text
      end
    end
  end

  Commerce.send :include, Webpay::Encryption
end