class Users::RegistrationsController < Devise::RegistrationsController
  include DeviseHelper
  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      render json: {message: 'User created successfully!'}
    else
      render json: {errors: resource.errors}
    end
  end
end
