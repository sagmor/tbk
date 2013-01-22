# Tbk

Pure Ruby implementation of Transbank's Webpay KCC 6.0

## Installation

Add this line to your application's Gemfile:

    gem 'tbk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tbk

## Usage

### Start a payment:
```ruby
class WebpayController < ApplicationController

  # Start a payment
  def pay
    commerce = TBK::Commerce.new({
      id: '597026007976',
      test: true,
      key: TBK::TEST_KEY
    })

    payment = TBK::Webpay::Payment.new({
      commerce: commerce,
      amount: 1000,
      order_id: 'ORDER_ID',
      success_url: webpay_success_url,
      confirmation_url: webpay_confirmation_url(host: 'SERVER_IP_ADDRESS')
    })

    redirect_to payment.redirect_url
  end

  # Confirmation callback
  def confirmation
    commerce = TBK::Commerce.new({
      id: '597026007976',
      test: true,
      key: TBK::TEST_KEY
    })

    confirmation = TBK::Webpay::Confirmation.new({
      commerce: commerce,
      body: request.body
    })

    # Order data is in confirmation.order_id
    # Paid amount is at confirmation.amount

    # Acknowledge payment
    render text: confirmation.acknowledge
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
