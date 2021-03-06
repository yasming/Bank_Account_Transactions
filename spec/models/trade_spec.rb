require 'rails_helper'

RSpec.describe Trade, type: :model do
  context "relationships" do
    context 'bank account' do
      it "one trade should have the bank account" do
        user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
        bank_account = BankAccount.create(user: user, amount: 1000)
        trade = Trade.create!(bank_account: bank_account,timestamp: Time.now, shares: 0, price: 1, trade_type: 0, symbol: 'APPL', state: 0)
        expect(trade.bank_account).to eq(bank_account)
      end
    end
  end
end
