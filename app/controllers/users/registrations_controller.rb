# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    build_resource({})
    resource.phone_numbers.build if resource.phone_numbers.empty?
    respond_with resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.role = 'individual'

    resource.save
    yield resource if block_given?

    if resource.persisted?
      # Handle phone number
      if params[:user][:phone_numbers_attributes].present?
        phone_number = resource.phone_numbers.create(
          number: params[:user][:phone_numbers_attributes]['0'][:number],
          primary: true,
          verification_attempts: 0
        )
        phone_number.generate_verification_code if phone_number.persisted?
      end

      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name, :last_name,
      phone_numbers_attributes: [:number, :primary]
    ])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, :last_name
    ])
  end

  def after_sign_up_path_for(resource)
    root_path
  end
end