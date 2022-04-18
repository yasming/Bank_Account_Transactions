require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  context "relationships" do
    context 'user' do
      it "one bank account should be able to get an user from it" do
        user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
        bank_account = BankAccount.create(user: user, amount: 1000)
        expect(bank_account.user.email).to eq('test@email.com')
      end
    end
  end

  context "validations" do
    it "it should validate presence of amount" do
      user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      bank_account = BankAccount.create(user: user)
      expect(bank_account.errors[:amount].to_a.last).to eq("can't be blank")
      expect(bank_account.errors[:amount].to_a.first).to eq('is not a number')
    end
    it "it should validate presence of amount" do
      user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      bank_account = BankAccount.create(user: user, amount: -1)
      expect(bank_account.errors[:amount].to_a.first).to eq('must be greater than or equal to 0')
    end
  end
end
