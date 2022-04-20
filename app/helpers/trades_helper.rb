module TradesHelper
  def create_trade(params)
    Trade.create!(params)
  end
end
