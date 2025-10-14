class Caretakers::ApplicationController < ApplicationController
  # Override the parent authentication requirement
  skip_before_action :authenticate_user!
  before_action :authenticate_caretaker!
  before_action :ensure_proper_caretaker_object
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def ensure_proper_caretaker_object
    return if devise_controller? # Skip for Devise controllers like sessions

    if current_caretaker.nil? || current_caretaker.is_a?(Hash)
      Rails.logger.error "Invalid caretaker object: #{current_caretaker.class} - #{current_caretaker.inspect}"
      reset_session
      redirect_to new_caretaker_session_path, alert: "Please sign in again."
    end
  end

  # Override current_caretaker to handle Hash issue
  def current_caretaker
    @current_caretaker ||= begin
      caretaker = super

      Rails.logger.debug "Raw current_caretaker from Devise: #{caretaker.inspect}"
      Rails.logger.debug "Class: #{caretaker.class}"

      # If it's a hash (session corruption), find the actual object
      if caretaker.is_a?(Hash)
        Rails.logger.warn "current_caretaker is a Hash, converting to Caretaker object"
        caretaker_id = caretaker["id"] || caretaker[:id]
        if caretaker_id
          found_caretaker = Caretaker.find_by(id: caretaker_id)
          Rails.logger.debug "Found caretaker: #{found_caretaker&.email}"
          found_caretaker
        else
          Rails.logger.error "No caretaker ID found in hash"
          nil
        end
      else
        caretaker
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name, :last_name, :phone, :license_number, :specialization,
      :years_experience, :terms_accepted
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, :last_name, :phone, :specialization, :years_experience
    ])
  end

  def after_sign_in_path_for(resource)
    caretakers_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_caretaker_session_path
  end
end
