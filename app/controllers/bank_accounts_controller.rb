class BankAccountsController < ApplicationController
  before_action :authorize_request

  def index
    bank_accounts = current_user.filter_bank_accounts_by_id(params[:bank_account_id]).map do |account|
      {
        'id'     => account.id,
        'amount' => account.amount
      }
    end
    render json: {bank_accounts: bank_accounts}
  end

  def create
    begin
      BankAccount.create!(amount: bank_accounts_params[:amount], user: current_user)
      render json: {message: 'Bank Account created!'}
    rescue => e
      render json: {errors: e.message}, status: :unprocessable_entity
    end
  end

  private
  def bank_accounts_params
    params.permit(:amount)
  end
end
