# frozen_string_literal: true

class ErrorsController < ApplicationController
  def error_404
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end
end
