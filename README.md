### About
[![Gem Version](https://badge.fury.io/rb/tbk.png)](http://badge.fury.io/rb/tbk)

This is a pure ruby replacement of Transbank's Binary Integration Kit (aka. KCC)
developed to simplify the integration with it's payment gateway Webpay.


### Disclaimer

This library is not developed, supported nor endorsed in any way by Transbank S.A.
and is the result of reverse engineering Transbank's Integration Kit (aka. KCC)
for interoperability purposes as allowed by
[Chilean Law 20.435 Article 71 Ñ Section b](http://www.leychile.cl/Navegar?idNorma=1012827)

### Usage

Add this line to your application's Gemfile:

```ruby
gem 'tbk'
```

To start a payment from your application

```ruby
class WebpayController < ApplicationController

  # ...

  # Start a payment
  def pay
    # Initialyze you commerce
    @commerce = TBK::Commerce.new({
      id: YOUR_COMMERCE_ID,
      key: YOUR_RSA_KEY
    })

    # Setup the payment
    @payment = TBK::Webpay::Payment.new({
      commerce: @commerce,
      amount: ORDER_AMOUNT,
      order_id: ORDER_ID,
      success_url: webpay_success_url,
      # Webpay can only access the HTTP protocol to a direct IP address (keep that in mind)
      confirmation_url: webpay_confirmation_url(host: SERVER_IP_ADDRESS, protocol: 'http'),

      # Optionaly supply:
      session_id: SOME_SESSION_VALUE,
      failure_url: webpay_failure_url # success_url is used by default
    })

    # Redirect the user to Webpay
    redirect_to @payment.redirect_url
  end

  # ...
end
```

And to process a payment

```ruby
class WebpayController < ApplicationController

  # ...

  # Confirmation callback executed from Webpay servers
  def confirmation
    # Initialyze you commerce
    @commerce = TBK::Commerce.new({
      id: YOUR_COMMERCE_ID,
      key: YOUR_RSA_KEY
    })

    # Read the confirmation data from the request
    @confirmation = TBK::Webpay::Confirmation.new({
      commerce: @commerce,
      post: request.raw_post
    })

    if # confirmation is invalid for some reason (wrong order_id or amount, double payment, etc...)
      render text: @confirmation.reject
      return # reject and stop execution
    end

    if @confirmation.success?
      # EXITO!
      # perform everything you have to do here.
    end

    # Acknowledge payment
    render text: @confirmation.acknowledge
  end

  # ...

end
```

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
