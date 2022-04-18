require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "It should register an user" do
    it "should create a new user" do
      expect(User.count).to eq(0)
      post '/users', params: {user: {email: "user@email.com", password: "12346#Qq", name: "test", surname: "test2"}}
      expect(response.status).to eq(200)
      expect(User.count).to eq(1)
      expect(JSON.parse(response.body)['message']).to eq("User created successfully!")
    end
  end
end
