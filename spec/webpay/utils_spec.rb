require 'spec_helper'

describe Webpay::Utils do

  describe "#chop" do
    
    it "should split strings in an array of fixed length strings" do
      Webpay::Utils.chop("whitespace",3).should == ["whi","tes","pac","e"]
    end

  end

end

