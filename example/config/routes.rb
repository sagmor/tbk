Example::Application.routes.draw do

  root to: 'webpay#show'
  post '/webpay/pay'
  post '/webpay/confirmation'
  match '/webpay/success'
  match '/webpay/failure'
end
