require 'rails_helper'

RSpec.describe "Trades", type: :request do
  describe "auth check" do
    it "should allow just logged in users to access the route" do
      get "/trades/1"
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['errors']).to eq("Nil JSON web token")
    end
  end

  describe "auth routes" do
    after(:context) { DatabaseCleaner.strategy = :truncation; DatabaseCleaner.clean }

    before(:all) do
      @user        = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      @bank_account = BankAccount.create(user: @user, amount: 12)
      @trade       = Trade.create!(trade_type: 1, bank_account: @bank_account, symbol: 'APPL', shares: 1, price: 1, state: 1, timestamp: Time.now)
      post '/auth/login', params: {email: @user.email, password: @user.password}
      @token = JSON.parse(response.body)['token']
    end

    describe "show" do
      it "should be able to return one trade" do
        get "/trades/#{@trade.id.to_s}",  headers: { Authorization:  @token}
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['trade']).to eq(@trade.as_json)
      end

      it "should return error in the trade is not found" do
        get "/trades/0",  headers: { Authorization:  @token}
        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)['errors']).to eq("Couldn't find Trade with 'id'=0")
      end
    end

    describe "edit" do
      it "should update a trade state" do
        get "/trades/#{@trade.id.to_s}/edit", params: {state: 0}, headers: { Authorization:  @token}
        @trade.reload
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq('Trade status updated!')
        expect(@trade.state).to eq("done")
      end

      it "should not allow to update a trade state if the trade state is different from pending" do
        trade = Trade.create!(trade_type: 1, bank_account: @bank_account, symbol: 'APPL', shares: 1, price: 1, state: 0, timestamp: Time.now)
        get "/trades/#{trade.id.to_s}/edit", params: {state: 1}, headers: { Authorization:  @token}
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['message']).to eq('Trade status cannot be updated!')
      end

      it "should not allow to update a trade if it is not found" do
        get "/trades/0/edit",  headers: { Authorization:  @token}
        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)['errors']).to eq("Couldn't find Trade with 'id'=0")
      end
    end

    describe "create" do
      it "should do not allow to create a trade with invalid records" do
        post "/trades", params: { trade: { shares: 0, trade_type: 0, bank_account_id:1, symbol: "APPL", price: 123, state: 3, timestamp: "now" }}, headers: { Authorization:  @token}
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['errors']).to eq("'3' is not a valid state")
      end
    end

  end

end
