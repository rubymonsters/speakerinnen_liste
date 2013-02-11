class Profile < ActiveRecord::Base
  attr_accessible :bio, :city, :email, :firstname, :languages, :lastname, :picture, :topics, :twitter
end
