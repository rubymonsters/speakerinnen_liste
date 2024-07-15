# encoding: utf-8

class ErrorsController < ApplicationController

  def not_found
    render status: :not_found
  end

  def unacceptable
    respond_to do |format|
      format.html.erb { render status: 422 }
    end
  end

  def internal_error
    respond_to do |format|
      format.html.erb { render status: 500 }
    end
  end

  def render_footer?
    true
  end
end
