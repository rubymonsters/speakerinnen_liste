class Profile < ActiveRecord::Base
  attr_accessible :bio, :city, :email, :firstname, :languages, :lastname, :picture, :topics, :twitter

  mount_uploader :picture, PictureUploader
end
