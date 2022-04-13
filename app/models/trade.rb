class Trade < ApplicationRecord
  belongs_to :bank_account
  enum status: [:done, :pending, :canceled]
  enum trade_type: [:buy, :sell]
end
