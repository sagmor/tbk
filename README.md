# Webpay Gem

## WARNING

Don't use this code since it uses a version of Transbank's KCC that posses a
serious security vulnerability.

## Disclaimer

This work is not developed, supported nor endorsed in any way by Transbank S.A.

## Usage

### Initialize a payment

```ruby
def checkout
  @commerce = Webpay::Commerce.new(COMMERCE_ID, PRIVATE_KEY_FILE_CONTENT)

  @payment = @commerce.payment({
    :amount => 1000,
    :order_id => "ORDER DATA",
    :session_id => "SESSION DATA", # OPTIONAL
    :notification_url => webpay_notification_url,
    :return_url => webpay_complete_url,
    :cancel_return_url => webpay_cancel_url, # OPTIONAL, defaults to :return_url
  })

  redirect_to @payment.redirect_url
end
```

#### Notification URL gotcha

Given the way Webpay works the notification_url param must be an HTTP URL (Webpay doesn't support HTTPS on the notification layer) with an IP address so anything like `http://1.2.3.4/webpay/notification/path` should work, for simplicity if you provide a host name instead of an IP address, the system will replace the host with the current machine IP address, but consider that depending of your network configuration it might not be the address you want.

### Confirm a payment

```ruby
def confirmation
  @commerce = Webpay::Commerce.new(COMMERCE_ID, PRIVATE_KEY_FILE_CONTENT)

  @confirmation = @commerce.confirmation(params)

  if @confirmation.success?
    # find order using @notification.order_id and @notification.session_id
    # validate amount using @notification.amount

    if # everything seems right
      # Perform your business logic to mark the order as payed
      # Note that if the payment is unsuccessfull we still have to answer ok to Webpay's notification
    else
      @confirmation.reject "Optional rejection reason"
    end
  end

  render :text => @confirmation.response
end
```

## License

Copyright (c) 2011 Sebastian Gamboa, http://sagmor.com/

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

