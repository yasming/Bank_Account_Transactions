require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it "validate unique email" do
      User.create!(email: 'test@email.com', password: '123##QQdsadsadasdsa', name: 'test', surname: 'test')
      user = User.create(email: 'test@email.com', password: '123##QQdsadsadasdsa')
      expect(user.errors[:email].to_a.first).to eq('has already been taken')
    end

    it "validate email presence" do
      user = User.create(password: '123##QQdsadsadasdsa')
      expect(user.errors[:email].to_a.first).to eq("can't be blank")
    end

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

    it "validate name presence" do
      user = User.create(email: 'test@email.com', password: 'asdfghjkQ#')
      expect(user.errors[:name].to_a.first).to eq("can't be blank")
    end

    it "validate surname presence" do
      user = User.create(email: 'test@email.com', password: 'asdfghjkQ#')
      expect(user.errors[:surname].to_a.first).to eq("can't be blank")
    end
  end
end
