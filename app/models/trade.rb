class Trade < ApplicationRecord
  belongs_to :bank_account
  enum state: [:done, :pending, :canceled]
  enum trade_type: [:buy, :sell]
  validates_inclusion_of :shares, :in => 0..100
  validates :price, numericality: true, presence: true
  validates :shares, presence: true
  validates :trade_type, presence: true
  validates :bank_account_id, presence: true
  validates :symbol, presence: true
  validates :price, presence: true
  validates :state, presence: true
  validates :timestamp, presence: true
  before_create :update_timestamp

  scope :filter_trade_by_type, ->(type) {
    where(trade_type: type) unless type.nil?
  }

  scope :filter_trade_by_state, ->(state) {
    where(state: state) unless state.nil?
  }

  scope :filter_trade_by_number, ->(number) {
    where(id: number) unless number.nil?
  }

  def update_timestamp
    self.timestamp = Time.now if self.timestamp == 'now'
  end

end
