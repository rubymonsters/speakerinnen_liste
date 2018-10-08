class RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: [:new]
end
