class TradesController < ApplicationController
  before_action :authorize_request

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

  private
  def trade_params
    params.require(:state)
  end
end
