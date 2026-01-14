class RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: [:create], on_spam: :spam_callback_method
end
