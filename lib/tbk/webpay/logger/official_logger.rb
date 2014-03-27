require 'pathname'

module TBK
  module Webpay
    module Logger
      class OfficialLogger < BaseLogger

        def directory(directory=nil)
          if directory
            @directory = Pathname(directory)

            # Create the directory if needed
            Dir.mkdir(@directory) unless Dir.exists?(@directory)
          end

          @directory
        end

        def payment(payment)
          events_log_file do |file|
            file.write PAYMENT_FORMAT % {
              date: now.strftime(LOG_DATE_FORMAT),
              time: now.strftime(LOG_TIME_FORMAT),
              pid: Process.pid,
              commerce_id: payment.commerce.id,
              transaction_id: payment.transaction_id,
              request_ip: payment.request_ip,
              token: payment.token,
              webpay_server: (payment.commerce.test? ? 'https://certificacion.webpay.cl' : 'https://webpay.transbank.cl')
            }
          end

          configuration_log_file do |file|
            response_uri = URI.parse(payment.confirmation_url)

            file.write CONFIGURATION_FORMAT % {
              commerce_id: payment.commerce.id,
              server_ip: response_uri.host,
              server_port: response_uri.port,
              response_path: response_uri.path,
              webpay_server: (payment.commerce.test? ? 'https://certificacion.webpay.cl' : 'https://webpay.transbank.cl'),
              webpay_server_port: (payment.commerce.test? ? '6433' : '433')
            }
          end
        end

        def confirmation(confirmation)
          events_log_file do |file|
            file.write CONFIRMATION_FORMAT % {
              date: now.strftime(LOG_DATE_FORMAT),
              time: now.strftime(LOG_TIME_FORMAT),
              pid: Process.pid,
              commerce_id: confirmation.commerce.id,
              transaction_id: confirmation.transaction_id,
              request_ip: confirmation.request_ip,
              order_id: confirmation.order_id,
            }
          end

          bitacora_log_file do |file|
            file.write BITACORA_FORMAT % confirmation.params.merge({
              commerce_id: confirmation.commerce.id
            })
          end
        end

        private
          def validate!
            unless self.directory
              raise ArgumentError, "#{self.class} requires a directory attribute"
            end
          end

          def now
            Time.now
          end

          def configuration_log_file(&block)
            log_file(CONFIGURATION_FILE_NAME, 'w+', &block)
          end

          def events_log_file(&block)
            name = EVENTS_LOG_FILE_NAME_FORMAT % now.strftime(EVENTS_LOG_FILE_DATE_FORMAT)

            log_file(name, &block)
          end

          def bitacora_log_file(&block)
            name = BITACORA_LOG_FILE_NAME_FORMAT % now.strftime(BITACORA_LOG_FILE_DATE_FORMAT)

            log_file(name, &block)
          end

          def log_file(name, mode='a+', &block)
            path = self.directory.join(name)

            File.open(path, mode, &block)
          end

        # Formats
        # Here comes an ugly part.
        # Check https://github.com/sagmor/tbk/pull/21#issuecomment-38714753 for the source of this formats.

        LOG_DATE_FORMAT = "%d%m%Y".freeze
        LOG_TIME_FORMAT = "%H%M%S".freeze
        CONFIGURATION_FILE_NAME = "tbk_config.dat".freeze
        EVENTS_LOG_FILE_NAME_FORMAT = "TBK_EVN%s.log".freeze
        EVENTS_LOG_FILE_DATE_FORMAT = "%Y%m%d".freeze
        BITACORA_LOG_FILE_NAME_FORMAT = "tbk_bitacora_TR_NORMAL_%s.log".freeze
        BITACORA_LOG_FILE_DATE_FORMAT = "%m%d".freeze
        PAYMENT_FORMAT = <<EOF.freeze
          ;%<pid>-12s;   ;Filtro    ;Inicio                                  ;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;                    ;Inicio de filtrado
          ;%<pid>-12s;   ;Filtro    ;tbk_param.txt                           ;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;                    ;Archivo parseado
          ;%<pid>-12s;   ;Filtro    ;Terminado                               ;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;                    ;Datos Filtrados con exito
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;inicio                                  ;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Parseo realizado
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Datos en datos/tbk_config.dat
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Mac generado
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Construccion TBK_PARAM
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;TBK_PARAM encriptado
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Datos listos para ser enviados
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Medio 1: Transaccion segura
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Datos validados
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Token=%<token>s
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Redireccion web
%<transaction_id>-10s;%<pid>-12s;   ;pago      ;%<webpay_server>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Todo OK
EOF

        CONFIRMATION_FORMAT = <<EOF.freeze
          ;%<pid>-12s;   ;resultado ;Desencriptando                          ;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;                    ;TBK_PARAM desencriptado
          ;%<pid>-12s;   ;resultado ;Validacion                              ;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;                    ;Entidad emisora de los datos validada
          ;%<pid>-12s;   ;resultado ;%<order_id>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;                    ;Parseo de los datos
          ;%<pid>-12s;   ;resultado ;%<order_id>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;                    ;http://127.0.0.1/webpay/notify
%<transaction_id>-10s;%<pid>-12s;   ;transacc  ;%<transaction_id>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;conectandose al port :(80)
%<transaction_id>-10s;%<pid>-12s;   ;resultado ;logro abrir_conexion                    ;%<date>-14s;%<date>-6s;%<request_ip>-15s; 0 ;%<commerce_id>-20s;Abrio socket para conex-com
%<transaction_id>-10s;%<pid>-12s;   ;transacc  ;%<transaction_id>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;POST a url http://127.0.0.1/webpay/notify
%<transaction_id>-10s;%<pid>-12s;   ;transacc  ;%<transaction_id>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;mensaje enviado
          ;%<pid>-12s;   ;check_mac ;                                        ;%<date>-14s;%<date>-6s;EMPTY          ;OK ;                    ;Todo OK
%<transaction_id>-10s;%<pid>-12s;   ;transacc  ;%<transaction_id>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Llego ACK del Comercio
%<transaction_id>-10s;%<pid>-12s;   ;resultado ;%<order_id>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;tienda acepto transaccion
%<transaction_id>-10s;%<pid>-12s;   ;resultado ;%<order_id>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;respuesta enviada a TBK (ACK)
%<transaction_id>-10s;%<pid>-12s;   ;resultado ;%<order_id>-40s;%<date>-14s;%<date>-6s;%<request_ip>-15s;OK ;%<commerce_id>-20s;Todo OK
EOF

        BITACORA_FORMAT = %w{
          ACK;
          TBK_ORDEN_COMPRA=%<TBK_ORDEN_COMPRA>s;
          TBK_CODIGO_COMERCIO=%<commerce_id>s;
          TBK_TIPO_TRANSACCION=%<TBK_TIPO_TRANSACCION>s;
          TBK_RESPUESTA=%<TBK_RESPUESTA>s;
          TBK_MONTO=%<TBK_MONTO>s;
          TBK_CODIGO_AUTORIZACION=%<TBK_CODIGO_AUTORIZACION>s;
          TBK_FINAL_NUMERO_TARJETA=%<TBK_FINAL_NUMERO_TARJETA>s;
          TBK_FECHA_CONTABLE=%<TBK_FECHA_CONTABLE>s;
          TBK_FECHA_TRANSACCION=%<TBK_FECHA_TRANSACCION>s;
          TBK_HORA_TRANSACCION=%<TBK_HORA_TRANSACCION>s;
          TBK_ID_SESION=%<TBK_ID_SESION>s;
          TBK_ID_TRANSACCION=%<TBK_ID_TRANSACCION>s;
          TBK_TIPO_PAGO=%<TBK_TIPO_PAGO>s;
          TBK_NUMERO_CUOTAS=%<TBK_NUMERO_CUOTAS>s;
          TBK_VCI=%<TBK_VCI>s;
          TBK_MAC=%<TBK_MAC>s
        }.join(' ').freeze

        CONFIGURATION_FORMAT = <<EOF.freeze
IDCOMERCIO = %<commerce_id>s
MEDCOM = 1
TBK_KEY_ID = 101
PARAMVERIFCOM = 1
URLCGICOM = %<response_path>s
SERVERCOM = %<server_ip>s
PORTCOM = %<server_port>s
WHITELISTCOM = ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz 0123456789./:=&?_
HOST = %<server_ip>s
WPORT = %<server_port>s
URLCGITRA = /filtroUnificado/bp_revision.cgi
URLCGIMEDTRA = /filtroUnificado/bp_validacion.cgi
SERVERTRA = %<webpay_server>s
PORTTRA = %<webpay_server_port>s
PREFIJO_CONF_TR = HTML_
HTML_TR_NORMAL = http://127.0.0.1/webpay/notify
EOF

      end
    end
  end
end
