class CreateTradeJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3
  queue_as :default
  include TradesHelper

  def perform(params)
    create_trade(params)
  end
end
