class Profile < ActiveRecord::Base

  def initialize
    ActsAsTaggableOn.delimiter = ' '
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :bio, :city, :email, :firstname, :languages, :lastname, :picture, :twitter, :remove_picture, :talks
  attr_accessible :content, :name, :topic_list
  acts_as_taggable_on :topics

  mount_uploader :picture, PictureUploader

  def fullname
    "#{firstname} #{lastname}"
  end
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |profile|
      profile.provider = auth.provider
      profile.uid = auth.uid
      profile.firstname = auth.info.nickname
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
  
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |profile|
        profile.attributes = params
        profile.valid?
      end
    else
      super
    end    
  end
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |profile|
      profile.provider = auth.provider
      profile.uid = auth.uid
      profile.firstname = auth.info.nickname
    end
  end
  
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |profile|
        profile.attributes = params
        profile.valid?
      end
    else
      super
    end    
  end

end



