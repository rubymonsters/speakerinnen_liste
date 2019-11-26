# encoding: utf-8

class ErrorsController < ApplicationController
  # skip_before_action :authenticate_admin!
  #according to the tutorial this is needed to bypaa the gem device, otherwise a user has to be logged in to see error pages. but it work's withut this line and dosn't work with it because the method is not defined.

  def not_found
    respond_to do |format|
      format.html.erb { render status: 404 }
    end
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
