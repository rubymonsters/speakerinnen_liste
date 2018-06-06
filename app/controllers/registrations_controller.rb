class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha,
                        only: [:create], # Change this to be any actions you want to protect.
                        if: 'Rails.env.production?'

  private

  def check_captcha
    unless verify_recaptcha || f.object.password_required? == false
      self.resource = resource_class.new sign_up_params
      respond_with_navigational(resource) { render :new }
    end
  end
end
