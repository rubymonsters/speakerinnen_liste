class AdminController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all
  end
end
