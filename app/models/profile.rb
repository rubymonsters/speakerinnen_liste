class Profile < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :bio, :city, :email, :firstname, :languages, :lastname, :picture, :topics, :twitter, :remove_picture

  mount_uploader :picture, PictureUploader

  def self.restricted_search (query)
    search_by_bio(query)
  end

  def is_admin?
    email == "jane_admin@server.org"
  end
end



