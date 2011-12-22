require 'spec_helper'

describe Webpay::Confirmation do

  before(:each) do
    @confirmation = Webpay::Commerce.test.confirmation({
      "TBK_PARAM" => <<EOF,
rsA934ZWsnJ8HMrqYQfE7SIwinHJKF71Tpyu6Y8hGp1OGmHnYOx7wOWCbfNK1XQj
W9kN9EbbZHmrQ9q4-GN7aC4jYF386ddiO7oPzJFJJmGXVGOnfxFJImXrt1H5H2R2
w.1aB6PHBUX1K2rN7OhiKx6M4yiU0TTBGipKpJgUA4bTze1sRnnWV-ncKysvzv9s
uBNaWX8rQw21TkG9RT-ZpP4r9XY0zxy6fiPRpkeAlz3uDlNxT7Iy0tKPltP1t-.Z
Ib3RHOODrlyY1nTRTC9QiiRYiphaP1-ZURLp5S-jl-xiy0uUooiqGEpus8W1L8Gl
C.HQ57iCp5YYH6gzaz9wk0rzo4MVUvnivgm-B5RAPHF-NI-qxjp41sWMtpwOHwnt
sQIvnANyIVYuvKp7bsCkg.8n.YOZ-PFX0ma91eAQG0npLbougBMkMkesNuaN-Dzn
oclyIffxId56zefpU6oPBuBDcF0JV0A72Bi5eWif8D5EogFwxc1tXdLxhSR5gOpq
EOF
      "TBK_CODIGO_COMERCIO" => "597026016975",
      "TBK_CODIGO_COMERCIO_ENC" => <<EOF,
a--1l4tj58As66nShcMeJGKdRr3tHcKhjM0pxp2Tbx2RhO037.ZiSItwkiXfGfuD
YQkm9hafEI97J8zrEYcirmQXEf7U4d1B3ZjQDt0MZPncLLHdp56BZSSNYLet3fYM
NZAbCpnfo8I98dR1ojUuzGtuYzJCZ4DzMsEB1WWdKKY_
EOF
      "OK" => "webpay"

    })
  end

  it "should be valid" do
    @confirmation.should be_valid
  end

  it "should be successful" do
    @confirmation.should be_success
  end

  # it "should return the payed ammount" do
  #   amount = @confirmation.amount
  #   amount.should be_kind_of Float
  #   amount.should == 500000.0
  # end


end



