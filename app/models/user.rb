class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, format: { with: /(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}/ }
  validates :name, presence: true
  validates :surname, presence: true
  has_many :bank_accounts
  after_create :create_new_bank_account

  private

  def create_new_bank_account
    BankAccount.create!(user: self, amount: 1000)
  end
end
