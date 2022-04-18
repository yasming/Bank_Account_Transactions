class User < ApplicationRecord
  devise(
    :database_authenticatable,
    :recoverable,
    :registerable,
  )
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, format: { with: /(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}/ }
  validates :name, presence: true
  validates :surname, presence: true
  after_create :create_new_bank_account
  has_many :bank_accounts

  def filter_bank_accounts_by_id(bank_account_id)
    return self.bank_accounts if bank_account_id.nil?
    self.bank_accounts.where(id: bank_account_id)
  end

  private

  def create_new_bank_account
    BankAccount.create!(user: self, amount: 1000)
  end
end
