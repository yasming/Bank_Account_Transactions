class TradesController < ApplicationController
  before_action :authorize_request
  include TradesHelper

  def show
    render json: {trade: Trade.find(params[:id])}
    rescue ActiveRecord::RecordNotFound
      render json: {errors: "Couldn't find Trade with 'id'=#{params[:id]}"}, status: :not_found
  end

  def edit
    begin
      trade = Trade.find(params[:id])
      if trade.state == 'pending'
        trade.update!(state: trade_params.to_i)
        render json: {message: 'Trade status updated!'}
        return
      end
      render json: {message: 'Trade status cannot be updated!'}, status: :unprocessable_entity
    rescue => e
      render json: {errors: e.message}, status: :not_found
    end
  end

  def create
    if trade_params_create[:timestamp] == 'now'
      begin
        create_trade(trade_params_create)
      rescue => e
        render json: {errors: e.message}, status: :unprocessable_entity
        return
      end
    end

    if trade_params_create[:timestamp].to_datetime < Time.now
      render json: {message: 'Invalid time for trade!'}, status: :unprocessable_entity
      return
    end

    CreateTradeJob.set(wait_until: trade_params_create[:timestamp].to_datetime).perform_later(trade_params_create)
    render json: {message: 'Trade created!'}
  end

  private
  def trade_params
    params.require(:state)
  end

  def trade_params_create
    params.require(:trade).permit(:state, :shares, :trade_type, :bank_account_id, :symbol, :price, :state, :timestamp)
  end
end
