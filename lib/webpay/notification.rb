module Webpay
  class Notification
    ACK = "ACK"
    ERR = "ERR"

    attr_reader :attributes

    def initialize(commerce, params)
      @commerce = commerce
      @params = params

      decrypt!
    end

    def valid?
      @params['TBK_PARAM_DEC'] &&
        @params['TBK_CODIGO_COMERCIO'] == @commerce.id.to_s &&
        @commerce.decrypt(@params['TBK_CODIGO_COMERCIO_ENC']) == @commerce.id.to_s &&
        @commerce.mac( @params['TBK_PARAM_DEC'].split("#")[0...-1].join("&") ) == mac
    rescue
      # Validation failed
      false
    end

    def success?
      attributes["TBK_RESPUESTA"] == "0"
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
      attributes["TBK_FINAL_NUMERO_TARJETA"]
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

    def ok
      ACK
    end

    def error
      ERR
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
        rescue
          # Decryption failed
        end
        
        true
      end
  end
end
