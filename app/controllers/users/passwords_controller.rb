class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  include DeviseHelper

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: {message: "Email with instructions sent!"}
    else
      render json: {message: "Email could not be sent!"}, status: :unprocessable_entity
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      render json: {message: "Password Updated!"}
    else
      render json: {errors: resource.errors}, status: :unprocessable_entity
    end
  end
end
