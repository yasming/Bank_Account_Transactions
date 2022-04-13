require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    context "email" do
      it "validate unique email" do
        User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
        user = User.create(email: 'test@email.com', password: '123##QQdsadsadasdsa')
        expect(user.errors[:email].to_a.first).to eq('has already been taken')
      end

      it "validate email presence" do
        user = User.create(password: '123##QQdsadsadasdsa')
        expect(user.errors[:email].to_a.first).to eq("can't be blank")
      end
    end

    context "password" do
      it "validate password presence" do
        user = User.create(email: 'test@email.com')
        expect(user.errors[:password].to_a.first).to eq("can't be blank")
      end

      it "validate password format length" do
        user = User.create(email: 'test@email.com', password: '123')
        expect(user.errors[:password].to_a.first).to eq('is invalid')
      end

      it "validate password format special letter" do
        user = User.create(email: 'test@email.com', password: '123456789Q')
        expect(user.errors[:password].to_a.first).to eq('is invalid')
      end

      it "validate password format capital letter" do
        user = User.create(email: 'test@email.com', password: '123456789#')
        expect(user.errors[:password].to_a.first).to eq('is invalid')
      end

      it "validate password format number" do
        user = User.create(email: 'test@email.com', password: 'asdfghjkQ#')
        expect(user.errors[:password].to_a.first).to eq('is invalid')
      end

    end

    context 'name' do
      it "validate name presence" do
        user = User.create(email: 'test@email.com', password: 'asdfghjkQ#')
        expect(user.errors[:name].to_a.first).to eq("can't be blank")
      end
    end

    context 'surname' do
      it "validate surname presence" do
        user = User.create(email: 'test@email.com', password: 'asdfghjkQ#')
        expect(user.errors[:surname].to_a.first).to eq("can't be blank")
      end
    end
  end

  context "relationships" do
    context 'bank_account' do
      it "one user has many bank accounts" do
        user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
        BankAccount.create(user: user, amount: 1000)
        BankAccount.create(user: user, amount: 1000)
        expect(user.bank_accounts.count).to eq(3)
      end
    end
  end

  context "after create" do
    it "it should create a bank account after user being created, with amount equals to 10000" do
      user = User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      expect(user.bank_accounts.count).to eq(1)
      expect(user.bank_accounts.first.amount).to eq(1000)
    end
  end
end
