# encoding: utf-8
module WebpayHelper

  # #########################################################################
  # Human readable transaction attributes helpers
  # #########################################################################
  #
  # Conventions:
  #
  # Human readable attributes can be SPECIFIED by a normative document which
  # specifies their formats. And it can be REQUIRED by a normative document
  # which, however, does not specify any format for them. Finally, they can be
  # DOCUMENTED, in which case they're not required and their formats are not
  # specified.
  #
  # Human readable attributes helpers are named in spanish in order to fit
  # closely to the business domain they belong to.
  #
  # #########################################################################


  # Public: Human readable number of instalments as specified in [1].
  #
  #   [1]: Manual de integración KCC 6.0, anexo C
  #
  # tbk_numero_cuotas - the String TBK_NUMERO_CUOTAS provided by Transbank
  #
  # Example:
  #
  #    cantidad_de_cuotas('0')
  #    # => "00"
  #
  # Returns the human readable number of instalments as a String.
  def cantidad_de_cuotas tbk_numero_cuotas
    tbk_numero_cuotas == '0' ? "00" : tbk_numero_cuotas
  end

  # Public: Human readable legal date as required in [1].
  #
  #   [1]: Manual de integración KCC 6.0
  #
  # tbk_fecha_contable - the String TBK_FECHA_CONTABLE provided by Transbank
  #
  # Example:
  #
  #    fecha_contable('0130')
  #    # => Wed, 30 Jan 2013
  #
  # Returns the human readable legal Date.
  def fecha_contable tbk_fecha_contable
    year = Time.now.year
    month = tbk_fecha_contable.to_datetime.month
    day = tbk_fecha_contable.to_datetime.day
    Date.new(year, month, day)
  end

  # Public: Human readable transaction date as required in [1].
  #
  #   [1]: Manual de integración KCC 6.0
  #
  # tbk_fecha_transaccion - the String TBK_FECHA_TRANSACCION by Transbank
  #
  # Example:
  #
  #    fecha_de_transaccion('0130')
  #    # => Wed, 30 Jan 2013
  #
  # Returns the human readable transaction Date.
  def fecha_de_transaccion tbk_fecha_transaccion
    year = Time.now.year
    month = tbk_fecha_transaccion.to_datetime.month
    day = tbk_fecha_transaccion.to_datetime.day
    Date.new(year, month, day)
  end

  # Public: Human readable transaction time as required in [1].
  #
  #   [1]: Manual de integración KCC 6.0
  #
  # tbk_hora_transaccion - the String TBK_HORA_TRANSACCION by Transbank
  #
  # Example:
  #
  #    hora_de_transaccion('0130')
  #    # => Wed, 30 Jan 2013
  #
  # Returns the human readable transaction Time.
  def hora_de_transaccion tbk_hora_transaccion
    hour, minute, second = tbk_hora_transaccion.scan( /.{1,2}/m ).map do |item| item.to_i end
    # only time is meaningful! To get the date and time, use WebpayHelpers.fecha_y_hora_de_transaccion() instead
    Time.new(2013, 01, 01, hour, minute, second)
  end

  # Public: Human readable transaction date and time as required in [1].
  #
  #   [1]: Manual de integración KCC 6.0
  #
  # tbk_fecha_transaccion - the String TBK_FECHA_TRANSACCION by Transbank
  # tbk_hora_transaccion - the String TBK_HORA_TRANSACCION provided by Transbank
  #
  # Example:
  #
  #    fecha_y_hora_de_transaccion('0714', '193100')
  #    # => 2013-07-14T19:31:00+00:00
  #
  # Returns the human readable transaction DateTime.
  def fecha_y_hora_de_transaccion tbk_fecha_transaccion, tbk_hora_transaccion
    year = Time.now.year
    month = tbk_fecha_transaccion.to_datetime.month
    day = tbk_fecha_transaccion.to_datetime.day
    hour, minute, second = tbk_hora_transaccion.scan( /.{1,2}/m ).map do |item| item.to_i end
    DateTime.new(year, month, day, hour, minute, second)
  end


  # Public: Human readable credit card number as required in [1].
  #
  #   [1]: Manual de integración KCC 6.0
  #
  # tbk_final_numero_tarjeta - the String TBK_FINAL_NUMERO_TARJETA by Transbank
  #
  # Example:
  #
  #    final_del_numero_de_tarjeta('3482')
  #    # => "XXXX-XXXX-XXXX-3482"
  #
  # Returns the human readable credit card number String.
  def final_del_numero_de_trajeta tbk_final_numero_tarjeta
    "XXXX-XXXX-XXXX-#{ tbk_final_numero_tarjeta }"
  end

  # Public: Human readable credit card number as required in [1].
  #
  #   [1]: Manual de integración KCC 6.0
  #
  # tbk_monto - the String TBK_MONTO provided by Transbank
  #
  # Example:
  #
  #    monto('500000')
  #    # => "$ 5.000,00"
  #
  # Returns the human readable credit card number String.
  def monto tbk_monto
    number_to_currency( tbk_monto.to_f/100.00, :unit => "$", :separator => ",", :delimiter => ".", :format => "%u %n" )
  end

  # Public: Human readable Transbank response as specified in [1].
  #
  #   [1]: Manual de integración KCC 6.0, sección 9.3
  #
  # tbk_respuesta - the String TBK_RESPUESTA provided by Transbank
  #
  # Example:
  #
  #    respuesta('0')
  #    # => "Transacción aprobada."
  #
  # Returns the human readable Transbank response String.
  def respuesta tbk_respuesta
    case tbk_respuesta
    when '0'
      'Transacción aprobada'
    when '-1'
      'Rechazo de transacción'
    when '-2'
      'Transacción debe reintentarse'
    when '-3'
      'Error en transacción'
    when '-4'
      'Rechazo de transacción'
    when '-5'
      'Rechazo por error de tasa'
    when '-6'
      'Excede cupo máximo mensual'
    when '-7'
      'Excede límite diario por transacción'
    when '-8'
      'Rubro no autorizado'
    else
      raise 'Unknown attribute.'
    end
  end

  # Public: Human readable Transbank payment type as specified in [1].
  #
  #   [1]: Manual de integración KCC 6.0, anexo C
  #
  # tbk_respuesta - the String TBK_TIPO_PAGO provided by Transbank
  #
  # Example:
  #
  #    respuesta('VD')
  #    # => "Débito"
  #
  # Returns the human readable payment type String.
  def tipo_de_pago tbk_tipo_pago
    case tbk_tipo_pago
    when 'VN'
      "Sin cuotas"
    when 'VC'
      "Cuotas normales"
    when 'SI'
      "3 cuotas sin intereses"
    when 'CI'
      "Cuotas comercio"
    when 'VD'
      "Débito"
    else
      raise 'Unknown attribute.'
    end
  end

  # Public: Human readable Transbank transaction type as documented in [1].
  #
  #   [1]: Manual de integración KCC 6.0, sección 8
  #
  # tbk_respuesta - the String TBK_TIPO_TRANSACCION provided by Transbank
  #
  # Example:
  #
  #    respuesta('TR_NORMAL')
  #    # => "Venta o pago normal"
  #
  # Returns the human readable transaction type String.
  def tipo_de_transaccion tbk_tipo_transaccion
    case tbk_tipo_transaccion
    when 'TR_NORMAL'
      'Venta o pago normal'
    when 'TR_MALL'
      'Venta o pago en mall virtual'
    else
      raise 'Unknown attribute.'
    end
  end
end
