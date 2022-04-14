Rails.application.routes.draw do
  devise_for :users, controllers: {
    passwords:  'users/passwords',
  }
  post '/auth/login', to: 'authentication#login'
  post '/auth/test-expired-token', to: 'authentication#test_expired_token'

end