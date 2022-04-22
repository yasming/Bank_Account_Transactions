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
    if trade_params_create[:state] == 0
      begin
        render json: {message: create_trade(trade_params_create)}
        return
      rescue => e
        render json: {errors: e.message}, status: :unprocessable_entity
        return
      end
    end
    timestamp =  trade_params_create[:timestamp].to_datetime.strftime('%Y-%m-%d %H:%M:%S')
    if Time.now.strftime('%Y-%m-%d %H:%M:%S') > timestamp
      render json: {errors: 'Invalid time for trade!'}, status: :unprocessable_entity
      return
    end

    CreateTradeJob.set(wait_until: timestamp).perform_later(trade_params_create)
    render json: {message: 'Trade created!'}
  end

  private
  def trade_params
    params.require(:state)
  end

  def trade_params_create
    params[:trade][:shares]          = params[:trade][:shares].to_i
    params[:trade][:trade_type]      = params[:trade][:trade_type].to_i
    params[:trade][:bank_account_id] = params[:trade][:bank_account_id].to_i
    params[:trade][:state]           = params[:trade][:state].to_i
    params[:trade][:price]           = params[:trade][:price].to_i
    params.require(:trade).permit(:state, :shares, :trade_type, :bank_account_id, :symbol, :state, :price, :timestamp)
  end
end
