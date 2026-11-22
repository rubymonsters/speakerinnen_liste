# frozen_string_literal: true

class SharepicsController < ApplicationController
  before_action :authenticate_profile!

  def index
    @sharepics = Sharepic.published.ordered.with_attached_image
  end

  def download
    sharepic = Sharepic.published.find(params[:id])
    redirect_to sharepic.image.url(disposition: :attachment, expires_in: 1.minute),
                allow_other_host: true
  end
end
