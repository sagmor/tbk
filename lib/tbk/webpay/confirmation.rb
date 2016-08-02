# encoding: UTF-8
module TBK
  module Webpay
    class Confirmation
      RESPONSE_CODES = {
        '0' => 'Transacción aprobada.',
        '-1' => 'Rechazo de tx. en B24, No autorizada',
        '-2' => 'Transacción debe reintentarse.',
        '-3' => 'Error en tx.',
        '-4' => 'Rechazo de tx. En B24, No autorizada',
        '-5' => 'Rechazo por error de tasa.',
        '-6' => 'Excede cupo máximo mensual.',
        '-7' => 'Excede límite diario por transacción.',
        '-8' => 'Rubro no autorizado.'
      }

      attr_accessor :commerce
      attr_accessor :request_ip
      attr_reader :raw
      attr_reader :params

      def initialize(options)
        options = { :body => options } if options.is_a?(String)

        self.commerce = options[:commerce] || TBK::Commerce.default_commerce
        self.request_ip = options[:request_ip]
        self.parse(options[:body])
      end

      def acknowledge
        self.commerce.webpay_encrypt('ACK')
      end

      def reject
        self.commerce.webpay_encrypt('ERR')
      end

      def success?
        self.params[:TBK_RESPUESTA] == "0"
      end

      def order_id
        self.params[:TBK_ORDEN_COMPRA]
      end

      def session_id
        self.params[:TBK_ID_SESION]
      end

      def transaction_id
        self.params[:TBK_ID_TRANSACCION]
      end

      def amount
        self.params[:TBK_MONTO].to_f/100
      end

      def authorization
        self.params[:TBK_CODIGO_AUTORIZACION]
      end

      def signature
        self.params[:TBK_MAC]
      end

      def card_display_number
        "XXXX-XXXX-XXXX-#{ card_last_numbers }"
      end

      def payment_type
        self.params[:TBK_TIPO_PAGO]
      end

      def installments
        self.params[:TBK_NUMERO_CUOTAS]
      end

      def card_last_numbers
        self.params[:TBK_FINAL_NUMERO_TARJETA]
      end

      def message
        RESPONSE_CODES[self.params[:TBK_RESPUESTA]]
      end

      def paid_at
        @paid_at ||= begin
          year = Time.now.year
          month = self.params[:TBK_FECHA_TRANSACCION][0...2].to_i
          day = self.params[:TBK_FECHA_TRANSACCION][2...4].to_i
          hour = self.params[:TBK_HORA_TRANSACCION][0...2].to_i
          minutes = self.params[:TBK_HORA_TRANSACCION][2...4].to_i
          seconds = self.params[:TBK_HORA_TRANSACCION][4...6].to_i

          offset = if defined? TZInfo::Timezone
            # Use tzinfo gem if available
            TZInfo::Timezone.get('America/Santiago').period_for_utc(DateTime.new(year,month,day,hour,minutes,0)).utc_offset
          else
            -14400
          end

          Time.new(year, month, day, hour, minutes, seconds, offset)
        end
      end


      protected
        def parse(post)
          @raw = post.to_s
          @raw_params = {}
          for line in @raw.split('&')
            key, value = *line.scan( %r{^([A-Za-z0-9_.]+)\=(.*)$} ).flatten
            @raw_params[key] = CGI.unescape(value)
          end

          @params = {}
          decrypted_params = self.commerce.webpay_decrypt(@raw_params['TBK_PARAM'])
          for line in decrypted_params[:body].split('#')
            key, value = *line.scan( %r{^([A-Za-z0-9_.]+)\=(.*)$} ).flatten
            @params[key.to_sym] = CGI.unescape(value)
          end
          @params[:TBK_MAC] = decrypted_params[:signature]

          TBK::Webpay.logger.confirmation(self)

          true
        end
    end
  end
end
