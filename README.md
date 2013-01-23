# TBK

Pure Ruby implementation of Transbank's Webpay KCC 6.0

## Disclaimer

This library is not developed, supported nor endorsed in any way by Transbank S.A.
and is the result of reverse engineering Transbank's Integration Kit (aka. KCC)
for interoperability purposes allowed by
[Chilean Law 20.435 Article 71 Ñ Section b(http://www.leychile.cl/Navegar?idNorma=1012827)

## Usage

Add this line to your application's Gemfile:

```ruby
gem 'tbk'
```

Setup a controller on your application

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
      post: request.body
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

## License

```
Copyright (c) 2013 Seba Gamboa

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
