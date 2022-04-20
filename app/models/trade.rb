class Trade < ApplicationRecord
  belongs_to :bank_account
  enum state: [:done, :pending, :canceled]
  enum trade_type: [:buy, :sell]

  scope :filter_trade_by_type, ->(type) {
    where(trade_type: type) unless type.nil?
  }

  scope :filter_trade_by_state, ->(state) {
    where(state: state) unless state.nil?
  }

  scope :filter_trade_by_number, ->(number) {
    where(id: number) unless number.nil?
  }

end
