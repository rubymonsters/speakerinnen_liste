class Profile < ActiveRecord::Base
  include AutoHtml

  auto_html_for :media_url do
    html_escape
    image
    youtube(:width => 400, :height => 250)
    vimeo(:width => 400, :height => 250)
    simple_format
  end

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  mount_uploader :picture, PictureUploader

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :bio, :city, :email, :firstname, :languages, :lastname, :picture, :twitter, :remove_picture, :talks
  attr_accessible :content, :name, :topic_list, :media_url
  acts_as_taggable_on :topics

  before_save(:on => [:create, :update]) do
    self.twitter.gsub!(/^@/, '') if twitter
  end

  def after_confirmation
    AdminMailer.new_profile_confirmed(self).deliver
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |profile|
      profile.provider = auth.provider
      profile.uid = auth.uid
      profile.twitter = auth.info.nickname
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

  def self.published
    where(published: true)
  end

  def self.no_admin
    where(:admin => false)
  end

  def fullname
    "#{firstname} #{lastname}".strip
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
end
