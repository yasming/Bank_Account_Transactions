Rails.application.routes.draw do
  devise_for :users, controllers: {
    passwords:  'users/passwords',
    registrations:  'users/registrations',
  }
  post '/auth/login', to: 'authentication#login'
  post '/auth/test-expired-token', to: 'authentication#test_expired_token'
  resources :bank_accounts, only: [:index, :create, :show]

end