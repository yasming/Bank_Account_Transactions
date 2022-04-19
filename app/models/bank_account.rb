class BankAccount < ApplicationRecord
  validates :amount, numericality: { greater_than_or_equal_to: 0 }, presence: true
  belongs_to :user
  has_many :trades

  def get_trades_filtered(params)
    self.trades.filter_trade_by_type(params[:type])
        .filter_trade_by_state(params[:state])
        .filter_trade_by_number(params[:number])
  end
end
