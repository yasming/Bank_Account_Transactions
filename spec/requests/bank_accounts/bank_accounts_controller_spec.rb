require 'rails_helper'

RSpec.describe "BankAccounts", type: :request do
  describe "auth check" do
    it "should allow just logged in users to access the route" do
      get '/bank_accounts'
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['errors']).to eq("Nil JSON web token")
    end
  end

  describe "index" do
    after(:context) { DatabaseCleaner.strategy = :truncation; DatabaseCleaner.clean }

    before(:all) do
      @user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      BankAccount.create(user: @user, amount: 12)
      @bank_accounts = @user.bank_accounts

      post '/auth/login', params: {email: @user.email, password: @user.password}
      @token = JSON.parse(response.body)['token']
    end

    it "should be able to return all bank accounts form the user" do
      get '/bank_accounts',  headers: { Authorization:  @token}
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['bank_accounts']).to eq(get_bank_accounts_endpoint_structure)
      expect(JSON.parse(response.body)['bank_accounts'].count).to eq(2)
    end

    it "should be able to filter by id" do
      bank_account = @bank_accounts.first
      get '/bank_accounts', params: {bank_account_id: bank_account.id}, headers: { Authorization:  @token}
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['bank_accounts'].count).to eq(1)
      expect(JSON.parse(response.body)['bank_accounts'].first["id"]).to eq(bank_account.id)
      expect(JSON.parse(response.body)['bank_accounts'].first["amount"]).to eq(bank_account.amount)
    end
  end

  describe "create" do
    after(:context) { DatabaseCleaner.strategy = :truncation; DatabaseCleaner.clean }

    before(:all) do
      @user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      post '/auth/login', params: {email: @user.email, password: @user.password}
      @token = JSON.parse(response.body)['token']
    end

    it "should create a new bank account" do
      post '/bank_accounts',  params: {amount: 100}, headers: { Authorization:  @token}
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq('Bank Account created!')
      expect(@user.bank_accounts.count).to eq(2)
      expect(@user.bank_accounts.last.amount).to eq(100)
    end

    it "should not create a new bank account with invalid value" do
      post '/bank_accounts', params: {amount: -10}, headers: { Authorization:  @token}
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)['errors']).to eq('Validation failed: Amount must be greater than or equal to 0')
      expect(@user.bank_accounts.count).to eq(1)
    end
  end

  private
  def get_bank_accounts_endpoint_structure
    @bank_accounts.map do |account|
      {
        "id"     => account.id,
        "amount" => account.amount
      }
    end
  end
end
