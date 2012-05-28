# -*- encoding: utf-8 -*-
module Webpay
  class Confirmation
    ACK = "ACK"
    ERR = "ERR"

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

    attr_reader :attributes

    def initialize(commerce, params)
      @commerce = commerce
      @params = params
      @accepted = true

      decrypt! && validate!
    end

    def valid?
      if @valid.nil?
        @valid = begin
          @params['TBK_PARAM_DEC'] &&
          @params['TBK_CODIGO_COMERCIO'] == @commerce.id.to_s &&
          @commerce.decrypt(@params['TBK_CODIGO_COMERCIO_ENC']) == @commerce.id.to_s &&
          @commerce.mac( @params['TBK_PARAM_DEC'].split("#")[0...-1].join("&") ) == mac
        rescue
          # Validation failed
          false
        end
      end

      @valid
    end

    def success?
      @accepted && attributes["TBK_RESPUESTA"] == "0"
    end

    def amount
      "#{attributes['TBK_MONTO'][0..-3]}.#{attributes['TBK_MONTO'][-2..-1]}".to_f
    end

    def order_id
      attributes["TBK_ORDEN_COMPRA"]
    end

    def session_id
      attributes["TBK_ID_SESION"]
    end

    def transaction_id
      attributes["TBK_ID_TRANSACCION"]
    end

    def authorization
      attributes["TBK_CODIGO_AUTORIZACION"]
    end

    def card_number
      if attributes["TBK_FINAL_NUMERO_TARJETA"]
        "XXXX-XXXX-XXXX-#{attributes["TBK_FINAL_NUMERO_TARJETA"]}"
      end
    end

    def message
      @message || I18n.translate( attributes["TBK_RESPUESTA"], scope: "webpay.responses", raise: true)
    rescue
      RESPONSE_CODES[ attributes["TBK_RESPUESTA"] ]
    end

    def accepted?
      @accepted
    end

    def payed_at
      Time.new(
        Time.now.year,
        attributes['TBK_FECHA_TRANSACCION'][0..1].to_i,
        attributes['TBK_FECHA_TRANSACCION'][2..3].to_i,
        attributes['TBK_HORA_TRANSACCION'][0..1].to_i,
        attributes['TBK_HORA_TRANSACCION'][2..3].to_i,
        attributes['TBK_HORA_TRANSACCION'][4..5].to_i,
        -14400 # CLT(GMT-4) (Not considering CLST(GMT-3) times
      )
    end

    def mac
      attributes["TBK_MAC"]
    end

    def reject(message=nil)
      @message = message
      @accepted = false
    end

    def response
      @accepted ? ACK : ERR
    end

    protected
      def decrypt!
        @attributes = {}
        begin
          @params['TBK_PARAM_DEC'] = @commerce.decrypt( @params['TBK_PARAM'] )

          @params['TBK_PARAM_DEC'].split('#').each do |attribute|
            key , value = attribute.split("=")
            @attributes[key] = value
          end

          true
        rescue
          # Decryption failed
          @valid = false
          reject "Decryption failed"
          false
        end
      end

      def validate!
        unless valid?
          reject "Validation failed"
        end
      end
  end
end
