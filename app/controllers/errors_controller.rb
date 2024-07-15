class ErrorsController < ApplicationController
  def not_found
    render status: :not_found
  end

  def bad_request
    render status: :bad_request
  end

  def unacceptable
    render status: :unprocessable_entity
  end

  def internal_error
    render status: :internal_server_error
  end

  def render_footer?
    true
  end
end
