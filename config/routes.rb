Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  post '/auth/test-expired-token', to: 'authentication#test_expired_token'

end