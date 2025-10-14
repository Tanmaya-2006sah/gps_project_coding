class Caretakers::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name, :last_name, :phone, :license_number,
      :specialization, :years_experience, :terms_accepted
    ])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, :last_name, :phone, :specialization, :years_experience
    ])
  end

  def after_sign_up_path_for(resource)
    caretakers_root_path
  end
end
