class Profile < ActiveRecord::Base
  include AutoHtml

  translates :bio, :main_topic, :fallbacks_for_empty_translations => true
  accepts_nested_attributes_for :translations

  auto_html_for :media_url do
    html_escape
    image
    youtube :width => 400, :height => 250
    vimeo :width => 400, :height => 250
    simple_format
    link :target => "_blank", :rel => "nofollow"
  end

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  mount_uploader :picture, PictureUploader

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :bio, :city, :email, :firstname, :languages, :lastname, :picture, :twitter, :remove_picture, :talks, :website
  attr_accessible :content, :name, :topic_list, :media_url, :medialinks, :main_topic
  attr_accessible :translations_attributes
  attr_accessible :admin_comment

  acts_as_taggable_on :topics

  has_many :medialinks

  before_save(:on => [:create, :update]) do
    self.twitter.gsub!(/^@|https:|http:|:|\/\/|www.|twitter.com\//, '') if twitter
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

  def self.is_published
    where(published: true)
  end

  def self.no_admin
    where(:admin => false)
  end

  def fullname
    "#{firstname} #{lastname}".strip
  end

  def main_topic_or_first_topic
    main_topic.present? ? main_topic.truncate(18, seperator: '') : topic_list.first
  end

  def language(translation)
    if translation.object.locale == :en && I18n.locale == :de
      "Englisch"
    elsif translation.object.locale == :en && I18n.locale == :en
      "English"
    elsif translation.object.locale == :de && I18n.locale == :en
      "German"
    else
      "Deutsch"
    end
  end

  def website_with_protocol
    if website =~ /^https?:\/\//
      return website
    else
      return 'http://'+ website
    end
  end

  def twitter_name_formatted
    twitter.gsub(/^@|https:|http:|:|\/\/|www.|twitter.com\//, '')
  end

  def twitter_link_formatted
    "http://twitter.com/"  + twitter.gsub(/^@|https:|http:|:|\/\/|www.|twitter.com\//, '')
  end

  def self.random
    order("RANDOM()")
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
