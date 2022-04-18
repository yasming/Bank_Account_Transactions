require 'rails_helper'

RSpec.describe "Users::Passwords", type: :request do
  describe "The user should be able recovery password" do
    it "after login it should return a token" do
      user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      expect(user.reset_password_token).to be_nil
      post '/users/password', params: {user: {email: user.email}}
      user.reload
      expect(response.status).to eq(200)
      expect(user.reset_password_token).not_to be_nil
      expect(JSON.parse(response.body)['message']).to eq("Email with instructions sent!")
    end

    it "should not allow send recovery token when email does not exist" do
      post '/users/password', params: {user: {email: 'test'}}
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['message']).to eq("Email could not be sent!")
    end

    it "should allow to update password with received token" do
      user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      expect(user.valid_password?('test1234%%')).to eq(false)
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      user.update!(reset_password_token: enc, reset_password_sent_at: Time.now)
      put '/users/password', params: {user: {password: 'test1234%%', password_confirmation: 'test1234%%', reset_password_token: raw}}
      user.reload
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq("Password Updated!")
      expect(user.valid_password?('test1234%%')).to eq(true)
    end
  end
end
