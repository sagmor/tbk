require 'spec_helper'

describe TBK::Commerce do
  context "creation" do
    it "can be done with all it's arguments" do
      @commerce = TBK::Commerce.new({
        :id => 12345,
        :key => TBK::Commerce::TEST_COMMERCE_KEY
      })

      expect(@commerce.id).to be_eql 12345
    end

    it "raises an exception if no id is given" do
      expect{
          TBK::Commerce.new({
            :key => TBK::Commerce::TEST_COMMERCE_KEY
          })
        }.to raise_error TBK::CommerceError
    end

    it "raises an exception if no key is given" do
      expect{
          TBK::Commerce.new({
            :id => 12345
          })
        }.to raise_error TBK::CommerceError
    end

  end

  context "default_commerce" do
    it "should be nil if no default is configured" do
      TBK.config.should_receive(:commerce_id).and_return nil
      expect(TBK::Commerce.default_commerce).to be_nil
    end

    it "should return a valid commerce if configured" do
      TBK.config.should_receive(:commerce_id).at_least(:once).and_return 12345
      TBK.config.should_receive(:commerce_key).at_least(:once).and_return TBK::Commerce::TEST_COMMERCE_KEY

      expect(TBK::Commerce.default_commerce).not_to be_nil
      expect(TBK::Commerce.default_commerce.id).to be_eql 12345
    end
  end
end
