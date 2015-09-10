class Profile < ActiveRecord::Base
  include AutoHtml
  include HasPicture

  translates :bio, :main_topic, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations

  auto_html_for :media_url do
    html_escape
    image
    youtube width: 400, height: 250
    vimeo width: 400, height: 250
    simple_format
    link target: '_blank', rel: 'nofollow'
  end

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  acts_as_taggable_on :topics

  has_many :medialinks

  before_save(on: [:create, :update]) do
    self.twitter.gsub!(/^@|https:|http:|:|\/\/|www.|twitter.com\//, '') if twitter
  end

  def after_confirmation
    AdminMailer.new_profile_confirmed(self).deliver
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |profile|
      profile.provider = auth.provider
      profile.uid = auth.uid
      profile.twitter = auth.info.nickname
    end
  end

  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do |profile|
        profile.attributes = params
        profile.valid?
      end
    else
      super
    end
  end

  scope :is_published, -> { where(published: true) }

  scope :no_admin, -> { where(admin: false) }

  def fullname
    "#{firstname} #{lastname}".strip
  end

  def name_or_email
    fullname.present? ? fullname : email
  end
  
  def main_topic_or_first_topic
    main_topic.present? ? main_topic : topic_list.first
  end

  def language(translation)
    if translation.object.locale == :en && I18n.locale == :de
      'Englisch'
    elsif translation.object.locale == :en && I18n.locale == :en
      'English'
    elsif translation.object.locale == :de && I18n.locale == :en
      'German'
    else
      'Deutsch'
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
    'http://twitter.com/'  + twitter.gsub(/^@|https:|http:|:|\/\/|www.|twitter.com\//, '')
  end

  def self.random
    order('RANDOM()')
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

  def as_json(options = {})
    attributes.slice(
      'id',
      'firstname',
      'lastname',
      'languages',
      'city',
      'twitter',
      'created_at',
      'updated_at',
      'website'
    ).merge(
      'medialinks' => medialinks,
      'topics' => topics.map(&:name),
      'picture' => picture,
      'bio' => bio_translations,
      'main_topic' => main_topic_translations
    )
  end

  #for simple admin search
  def self.search(query)
    where('firstname ILIKE :query OR lastname ILIKE :query OR twitter ILIKE :query', query: "%#{query}%")
  end
end
