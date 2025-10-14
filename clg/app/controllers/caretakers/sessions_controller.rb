class Caretakers::SessionsController < Devise::SessionsController
  layout "application"

  def create
    self.resource = warden.authenticate!(auth_options)

    # Force reload to ensure we have a proper object
    if resource.is_a?(Hash)
      Rails.logger.error "Caretaker authentication returned Hash, finding proper object"
      caretaker_id = resource["id"] || resource[:id]
      self.resource = Caretaker.find(caretaker_id) if caretaker_id
    end

    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)

    Rails.logger.info "Caretaker signed in: #{resource.email} (#{resource.class})"

    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def after_sign_in_path_for(resource)
    caretakers_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_caretaker_session_path
  end

  private

  def auth_options
    { scope: :caretaker }
  end
end
