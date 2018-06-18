# frozen_string_literal: true

module AuthHelper
  def http_login(name, token)
    ApiToken.create!(name: name, token: token)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(name, token)
  end
end
