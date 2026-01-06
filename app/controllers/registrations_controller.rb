class RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: [:create] , on_spam: :spam_callback_method
  private

  def spam_callback_method
    redirect_to root_path
  end
end
