module TBK
  module Webpay
    class Payment
      attr_accessor :commerce
      attr_accessor :amount
      attr_accessor :order_id
      attr_accessor :session_id
      attr_accessor :confirmation_url
      attr_accessor :success_url
      attr_accessor :failure_url

      def initialize(options = {})
        self.commerce = options[:commerce] || TBK::Commerce.default_commerce
        self.amount = options[:amount]
        self.order_id = options[:order_id]
        self.session_id = options[:session_id]
        self.confirmation_url = options[:confirmation_url]
        self.success_url = options[:success_url]
        self.failure_url = options[:failure_url]
      end

      # Transaction ids are generated randombly on the client side
      def transaction_id
        @transaction_id ||= (rand * 10000000000).to_i
      end

      def redirect_url
        "#{ self.process_url }?TBK_VERSION_KCC=#{ TBK::VERSION::KCC }&TBK_TOKEN=#{ self.token }"
      end

      def to_html_form(options = {}, &block)
        form = <<-EOF
          <form method="POST"
            class="#{ options[:class] || 'tbk_payment_form'}"
            id="#{ options[:id] }"
            action="#{ self.process_url }">
            <input type="hidden" name="TBK_PARAM" value="#{ self.param }">
            <input type="hidden" name="TBK_VERSION_KCC" value="#{ TBK::VERSION::KCC }">
            <input type="hidden" name="TBK_CODIGO_COMERCIO" value="#{ self.commerce.id }">
            <input type="hidden" name="TBK_KEY_ID" value="#{ self.commerce.webpay_key_id }">
            #{ yield if block_given? }
          </form>
        EOF

        form = form.html_safe if form.respond_to? :html_safe

        form
      end

      protected
        def process_url
          if self.commerce.test?
            "https://certificacion.webpay.cl:6443/filtroUnificado/bp_revision.cgi"
          else
            "https://webpay.transbank.cl:443/cgi-bin/bp_revision.cgi"
          end
        end

        def validation_url
          if self.commerce.test?
            "https://certificacion.webpay.cl:6443/filtroUnificado/bp_validacion.cgi"
          else
            "https://webpay.transbank.cl:443/cgi-bin/bp_validacion.cgi"
          end
        end

        def token
          @token ||= begin
            uri = URI.parse( self.validation_url )

            response = nil
            until response && response['location'].nil?
              uri = URI.parse( response.nil? ? self.validation_url : response['location'] )

              response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
                post = Net::HTTP::Post.new uri.path
                post["user-agent"] = "TBK/#{ TBK::VERSION::GEM } (Ruby/#{ RUBY_VERSION }; +#{ TBK::VERSION::WEBSITE })"
                post.set_form_data({
                  'TBK_VERSION_KCC' => TBK::VERSION::KCC,
                  'TBK_CODIGO_COMERCIO' => self.commerce.id,
                  'TBK_KEY_ID' => self.commerce.webpay_key_id,
                  'TBK_PARAM' => self.param
                })

                # http.read_timeout = Webpay::Config.timeout
                http.request post
              end
            end

            unless response.code == "200"
              raise TBK::Webpay::PaymentError, "Payment token generation failed"
            end

            response = self.commerce.webpay_decrypt(response.body)

            unless /ERROR=([a-zA-Z0-9]+)/.match(response)[1] == "0"
              raise TBK::Webpay::PaymentError, "Payment token generation failed"
            end

            /TOKEN=([a-zA-Z0-9]+)/.match(response)[1]
          end
        end

        def param
          @param ||= begin
            self.verify!
            self.commerce.webpay_encrypt(raw_params)
          end
        end

        def verify!
          raise TBK::Webpay::PaymentError, "Commerce required" if self.commerce.nil?
          raise TBK::Webpay::PaymentError, "Invalid amount (#{self.amount.inspect})" unless self.amount && self.amount > 0
          raise TBK::Webpay::PaymentError, "Order ID required" if self.order_id.nil?
          raise TBK::Webpay::PaymentError, "Success URL required" if self.success_url.nil?
          raise TBK::Webpay::PaymentError, "Confirmation URL required" if self.confirmation_url.nil?
          confirmation_uri = URI.parse(self.confirmation_url)
          raise TBK::Webpay::PaymentError, "Confirmation URL host MUST be an IP address" unless /(\d{1,3}\.){3}\d{1,3}/.match(confirmation_uri.host)
          raise TBK::Webpay::PaymentError, "Confirmation URL port MUST be 80 or 8080" unless [80, 8080].include?(confirmation_uri.port)
        end

        def raw_params(splitter="#", include_pseudomac=true)
          params = []

          params << "TBK_ORDEN_COMPRA=#{ self.order_id }"
          params << "TBK_CODIGO_COMERCIO=#{ self.commerce.id }"
          params << "TBK_ID_TRANSACCION=#{ self.transaction_id }"

          uri = URI.parse(self.confirmation_url)

          params << "TBK_URL_CGI_COMERCIO=#{ uri.path }"
          params << "TBK_SERVIDOR_COMERCIO=#{ uri.host }"
          params << "TBK_PUERTO_COMERCIO=#{ uri.port }"

          params << "TBK_VERSION_KCC=#{ TBK::VERSION::KCC }"
          params << "TBK_KEY_ID=#{ self.commerce.webpay_key_id }"
          params << "PARAMVERIFCOM=1"

          if include_pseudomac
            # An old pseudo mac generation carried from an old implementation
            digest = OpenSSL::Digest::MD5.new
            digest << self.raw_params('&',false) << self.commerce.id.to_s << "webpay"
            mac = digest.to_s

            params << "TBK_MAC=#{ mac }"
          end


          params << "TBK_MONTO=#{ (self.amount * 100).to_i }"
          params << "TBK_ID_SESION=#{ self.session_id }" if self.session_id
          params << "TBK_URL_EXITO=#{ self.success_url }"
          params << "TBK_URL_FRACASO=#{ self.failure_url || self.success_url }"
          params << "TBK_TIPO_TRANSACCION=TR_NORMAL"

          params.join(splitter)
        end
    end
  end
end
