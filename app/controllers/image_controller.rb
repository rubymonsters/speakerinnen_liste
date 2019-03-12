class ImageController < ApplicationController
  
  def destroy
    image = ActiveStorage::Attachment.find(params[:id])
    profile_id = image.record_id
    image.purge
    redirect_to profile_path(profile_id), notice: I18n.t('flash.image.destroyed')
  end
end
