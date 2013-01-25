module TestCommerce
  def test_commerce
    @test_commerce ||= TBK::Commerce.new({
      :id => 597026007976,
      :test => true
    })
  end
end

RSpec.configure do |config|
  config.include TestCommerce
end
