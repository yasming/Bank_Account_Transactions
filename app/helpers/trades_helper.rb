module TradesHelper

  def create_trade(params)
    trade        = Trade.create!(params)
    bank_account = trade.bank_account
    amount       = get_amount(trade, bank_account)
    if amount < 0
      trade.state = 'canceled'
      trade.save!
      return 'Trade Canceled because of amount value!'
    end
    bank_account.amount = amount
    bank_account.save!

    trade.state = 'done'
    trade.save!
    'Trade done!'
  end

  private
  def get_amount(trade, bank_account)
    amount = 0
    if trade.trade_type == 'buy'
      amount = bank_account.amount - trade.price
    end
    if trade.trade_type == 'sell'
      amount = bank_account.amount + trade.price
    end
    amount
  end
end
