# encoding: utf-8
require 'spec_helper'

describe WebpayHelper do

  before(:each) do
    @params = []
  end

  describe 'cantidad_de_cuotas' do
    context "when @params['TBK_NUMERO_CUOTAS'] is '0'" do
      it "returns '00'" do
        @params.should_receive(:[]).with('TBK_NUMERO_CUOTAS').and_return '0'

        expect(cantidad_de_cuotas(@params['TBK_NUMERO_CUOTAS'])).to be_eql '00'
      end
    end
  end

  describe 'respuesta' do
    context "when @params['TBK_RESPUESTA'] is '0'" do
      it "returns 'Transacción aprobada'" do
        @params.should_receive(:[]).with('TBK_RESPUESTA').and_return '0'

        expect(respuesta(@params['TBK_RESPUESTA'])).to be_eql 'Transacción aprobada'
      end
    end
    context "when @params['TBK_RESPUESTA'] is '-1'" do
      it "returns 'Rechazo de transacción'" do
        @params.should_receive(:[]).with('TBK_RESPUESTA').and_return '-1'

        expect(respuesta(@params['TBK_RESPUESTA'])).to be_eql 'Rechazo de transacción'
      end
    end
    context "when @params['TBK_RESPUESTA'] is '-2'" do
      it "returns 'Transacción debe reintentarse'" do
        @params.should_receive(:[]).with('TBK_RESPUESTA').and_return '-2'

        expect(respuesta(@params['TBK_RESPUESTA'])).to be_eql 'Transacción debe reintentarse'
      end
    end
    context "when @params['TBK_RESPUESTA'] is '-3'" do
      it "returns 'Error en transacción'" do
        @params.should_receive(:[]).with('TBK_RESPUESTA').and_return '-3'

        expect(respuesta(@params['TBK_RESPUESTA'])).to be_eql 'Error en transacción'
      end
    end
    context "when @params['TBK_RESPUESTA'] is '-4'" do
      it "returns 'Rechazo de transacción'" do
        @params.should_receive(:[]).with('TBK_RESPUESTA').and_return '-4'

        expect(respuesta(@params['TBK_RESPUESTA'])).to be_eql 'Rechazo de transacción'
      end
    end
    context "when @params['TBK_RESPUESTA'] is '-5'" do
      it "returns 'Rechazo por error de tasa'" do
        @params.should_receive(:[]).with('TBK_RESPUESTA').and_return '-5'

        expect(respuesta(@params['TBK_RESPUESTA'])).to be_eql 'Rechazo por error de tasa'
      end
    end
    context "when @params['TBK_RESPUESTA'] is '-6'" do
      it "returns 'Excede cupo máximo mensual'" do
        @params.should_receive(:[]).with('TBK_RESPUESTA').and_return '-6'

        expect(respuesta(@params['TBK_RESPUESTA'])).to be_eql 'Excede cupo máximo mensual'
      end
    end
    context "when @params['TBK_RESPUESTA'] is '-7'" do
      it "returns 'Excede límite diario por transacción'" do
        @params.should_receive(:[]).with('TBK_RESPUESTA').and_return '-7'

        expect(respuesta(@params['TBK_RESPUESTA'])).to be_eql 'Excede límite diario por transacción'
      end
    end
    context "when @params['TBK_RESPUESTA'] is '-8'" do
      it "returns 'Rubro no autorizado'" do
        @params.should_receive(:[]).with('TBK_RESPUESTA').and_return '-8'

        expect(respuesta(@params['TBK_RESPUESTA'])).to be_eql 'Rubro no autorizado'
      end
    end
  end

  describe 'tipo_de_pago' do
    context "when @params['TBK_TIPO_PAGO'] is 'VN'" do
      it "returns 'Sin cuotas'" do
        @params.should_receive(:[]).with('TBK_TIPO_PAGO').and_return 'VN'

        expect(tipo_de_pago(@params['TBK_TIPO_PAGO'])).to be_eql 'Sin cuotas'
      end
    end
    context "when @params['TBK_TIPO_PAGO'] is 'VC'" do
      it "returns 'Cuotas normales'" do
        @params.should_receive(:[]).with('TBK_TIPO_PAGO').and_return 'VC'

        expect(tipo_de_pago(@params['TBK_TIPO_PAGO'])).to be_eql 'Cuotas normales'
      end
    end
    context "when @params['TBK_TIPO_PAGO'] is 'SI'" do
      it "returns '3 cuotas sin intereses'" do
        @params.should_receive(:[]).with('TBK_TIPO_PAGO').and_return 'SI'

        expect(tipo_de_pago(@params['TBK_TIPO_PAGO'])).to be_eql '3 cuotas sin intereses'
      end
    end
    context "when @params['TBK_TIPO_PAGO'] is 'CI'" do
      it "returns 'Cuotas comercio'" do
        @params.should_receive(:[]).with('TBK_TIPO_PAGO').and_return 'CI'

        expect(tipo_de_pago(@params['TBK_TIPO_PAGO'])).to be_eql 'Cuotas comercio'
      end
    end
    context "when @params['TBK_TIPO_PAGO'] is 'VD'" do
      it "returns 'Débito'" do
        @params.should_receive(:[]).with('TBK_TIPO_PAGO').and_return 'VD'

        expect(tipo_de_pago(@params['TBK_TIPO_PAGO'])).to be_eql 'Débito'
      end
    end
  end
end
