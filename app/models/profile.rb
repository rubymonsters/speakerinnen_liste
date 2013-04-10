class Profile < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :bio, :city, :email, :firstname, :languages, :lastname, :picture, :twitter, :remove_picture, :talks
  attr_accessible :content, :name, :topic_list
  acts_as_taggable_on :topics

  mount_uploader :picture, PictureUploader
end



