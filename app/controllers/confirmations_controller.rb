class ConfirmationsController < Devise::ConfirmationsController
  
  protected

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    path = profile_path(resource.id)
    if Devise.allow_insecure_sign_in_after_confirmation
      path
    elsif signed_in?
      path
    else
      scope = Devise::Mapping.find_scope!(resource)
      session["#{scope}_return_to"] = path
      new_session_path(resource_name)
    end
  end
end