require 'spec_helper'

describe TBK::Config do

  it "should inject configuration methods on base module" do

    expect(TBK).to respond_to :configure
    expect(TBK).to respond_to :config
    expect(TBK.config).to be_kind_of TBK::Config

    TBK.configure do |config|
      expect(config).to be_kind_of TBK::Config
      expect(config).to be == TBK.config
    end

  end

  context('#commerce_id') do
    it "should be nil by default" do
      expect(TBK.config.commerce_id).to be_nil
    end

    it "should read it's default value from the environment" do
      ENV.should_receive(:[]).with('TBK_COMMERCE_ID').and_return "12345"

      expect(TBK.config.commerce_id).to be_eql "12345"
    end
  end

  context('#commerce_key') do
    it "should be nil by default" do
      expect(TBK.config.commerce_key).to be_nil
    end

    it "should read it's default value from the environment" do
      ENV.should_receive(:[]).with('TBK_COMMERCE_KEY').and_return "PKEY"

      expect(TBK.config.commerce_key).to be_eql "PKEY"
    end
  end

  context('#environment') do
    it "should be production by default" do
      expect(TBK.config.environment).to be_eql :production
    end

    it "should read it's default value from the environment" do
      ENV.should_receive(:[]).with('TBK_COMMERCE_ENVIRONMENT').and_return "test"

      expect(TBK.config.environment).to be_eql :test
    end
  end

end
