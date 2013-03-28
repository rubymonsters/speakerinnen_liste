class Profile < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :bio, :city, :email, :firstname, :languages, :lastname, :picture, :topics, :twitter, :remove_picture, :talks

  mount_uploader :picture, PictureUploader

  def self.restricted_search (query, columns_to_search)
    basic_search(query_combiner(query, columns_to_search), false)
  end

  def self.query_combiner (query, columns_to_search)
    combined_query = {}
    columns_to_search.each do |column| 
      combined_query.store(column, query)
    end
    combined_query
  end

  def self.safe_search_columns 
    [:bio, :firstname, :lastname, :topics, :languages, :city]
  end

  def self.safe_search (query)
    restricted_search(query, safe_search_columns)
  end

  def is_admin?
    email == "jane_admin@server.org"
  end
end



