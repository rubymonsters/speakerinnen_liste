class RegistrationsController < Devise::RegistrationsController

  protected

    def after_sign_out_path_for(resource)
      profiles_path
    end
end