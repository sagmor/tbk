require 'spec_helper'

describe Webpay::Base64 do

  before(:all) do
    @samples = {
      "Hello World" => "SGVsbG8gV29ybGQ_\n",
      OpenSSL::Digest::SHA512.new("").digest =>
        "z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg.SpIdNs6c5H0NE8XYXysP-DGNKHfuwv\nY7kxvUdBeoGlODJ6-SfaPg__\n",
      "The quick brown fox jumps over the lazy dog" => 
        "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw__\n"
    }
  end

  before(:each) do
    @encoder = Webpay::Base64
  end

  it "should encode strings using Webpay's variation of Base64" do
    @samples.each do |string,expected|
      @encoder.encode(string).should == expected
    end
  end

  it "should decode strings using Webpay's variation of Base64" do 
    @samples.each do |expected,string|
      @encoder.decode(string).should == expected
    end
  end

end
