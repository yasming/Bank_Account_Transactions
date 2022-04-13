require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  include ActiveSupport::Testing::TimeHelpers
  describe "The user should be able to login" do
    it "after login it should return a token" do
      user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      post '/auth/login', params: {email: user.email, password: user.password}
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['token']).not_to be_nil
    end

    it "it should expire a token after 30 minutes" do
      user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      post '/auth/login', params: {email: user.email, password: user.password}
      expect(response.status).to eq(200)
      expect(JsonWebToken.decode(JSON.parse(response.body)['token'])).not_to be_empty
      travel_to Time.current + 31.minutes
      begin
        JsonWebToken.decode(JSON.parse(response.body)['token'])
      rescue => e
        expect(e.message).to eq("Signature has expired")
      end
    end
  end
end
