module URI
  class << self
    # Webpay appends a weird "% a" instead of the propper \n encoding.
    def decode_www_form_component_with_webpay_fix(str, enc=Encoding::UTF_8)
      str = str.gsub("% a","\n")
      decode_www_form_component_without_webpay_fix(str, enc)
    end
    alias_method :decode_www_form_component_without_webpay_fix, :decode_www_form_component
    alias_method :decode_www_form_component, :decode_www_form_component_with_webpay_fix
  end
end
