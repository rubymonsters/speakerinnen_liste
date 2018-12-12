# frozen_string_literal: true

class ErrorsController < ApplicationController
  def error_404
	render :text => 'Not Found', :status => '404'
  end
end
