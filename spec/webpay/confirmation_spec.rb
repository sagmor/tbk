require 'spec_helper'

describe Webpay::Confirmation do

  before(:each) do
    @confirmation = Webpay::Commerce.test.confirmation({
      "TBK_PARAM" => <<EOF,
Hw2U6xB5eSl7proJ3tR.Owos0xAOxyMUcO7k62w2BdTCSzMJqPQpV1Bt9KKtq-LS
VgPmLdNlu4xfqv-KgLLr.R-5BH-ylwCizD5JehLKu8FVYIUznXxh.oSCCHnrdxEP
Q9DhAY5l0rHsIqxqk7uEeoTFjCMQ6r6WyoUlS935nzA2q3hv9sji-tVM5FVswGP0
G6RU6PVfCq1NYNDQUjU3KoiRUmKfGHMpRW5Qn7c.KcmSf4AmBoOmW9AL02tv0PW1
jNhPu.HI2UojO-Fn4cSf6FCcVBxxFWfOilO8lJCE6jZLIlbF2WJECU5v66Z82rBR
zKTAJ2EM5EefLLL1GvHy3c1lQThC8kRvL7PovLuPWKTVUegQqT4wOchHYzsAU0SY
gX8XLtN9-hpgfROPVec9C-Yj5HagfE6veJrB5xmLjmbFdsOjZD5V-rdSRYuYIBdz
B-ZEQw3xqN-yze0pxpC8rxTMrU7wv30Jr7rIMPCiyReN4SLyj69n5rdKn-ZcFUoe
Ituw0UwQCNhc3h25MtLL1rpjdtXnp2nWGSQaPH7MUver5K9Pj2WKXY68AvUeBbxl
p6cpfx.PFxjvstrRT2tiigVMO9Do88yS46TEgwFWFfRWPC3kNjUlXaDMNbuSP3Z0
xyhPg662gUMsdB.OTRJIoZBVnWddx0UpKdJ2kfnWdrE_
EOF
      "TBK_CODIGO_COMERCIO" => "597026016975",
      "TBK_CODIGO_COMERCIO_ENC" => <<EOF,
fgG2rm1KxrWvCda0nGgqll52GfFvrUjkq6n1T0jsksbSvuEYWrGMSwljfEZwHDc7
uskax9sss15ugUZ-Er532L.Ol24VDNVpU.yO1YdWmRl7.I9McCK2ig.jZPp5XcFN
KIF0sZAp2UMyTBK7qbcSrTmm0jubrrEib8VfV4cG7Ys_
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

  it "should calculate the payment time" do
    payed_at = @confirmation.payed_at
    payed_at.should be_kind_of Time
    payed_at.should == Time.new(Time.now.year,9,22,19,13,2,-14400)
  end

  it "should return the payed ammount" do
    amount = @confirmation.amount
    amount.should be_kind_of Float
    amount.should == 500000.0
  end


end


