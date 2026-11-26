# frozen_string_literal: true

class SharepicsController < ApplicationController
  def index
    @sharepics = Sharepic.published.ordered.with_attached_image
  end

  def download
    sharepic = Sharepic.published.find(params[:id])
    redirect_to rails_blob_path(sharepic.image, disposition: :attachment)
  end
end
