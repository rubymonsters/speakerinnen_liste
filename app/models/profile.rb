class Profile < ApplicationRecord
  include AutoHtml
  include HasPicture
  include Searchable
  include ActiveModel::Serialization

  has_many :medialinks

  serialize :iso_languages, Array
  validate :iso_languages_array_has_right_format
  before_save :clean_iso_languages!

  translates :bio, :main_topic, :twitter, :website, :city, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  globalize_accessors locales: %i[en de], attributes: %i[main_topic bio twitter website city]

  extend FriendlyId
  friendly_id :slug_candidate, use: :slugged

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

  before_save(on: %i[create update]) do
    twitter.gsub!(%r{^@|https:|http:|:|//|www.|twitter.com/}, '') if twitter
    firstname.strip! if firstname
    lastname.strip! if lastname
  end

  after_save :update_or_remove_index

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

  scope :is_confirmed, -> { where.not(confirmed_at: nil) }

  scope :no_admin, -> { where(admin: false) }

  # only show profile where the main_topic is filled in in the current locale
  scope :main_topic_translated_in, ->(locale) {
    joins('INNER JOIN profile_translations ON profile_translations.profile_id = profiles.id')
      .where('profile_translations.locale' => locale)
      .where.not('profile_translations.main_topic' => [nil, ''])
  }

  def fullname
    "#{firstname} #{lastname}".strip
  end

  def cities
    cities_de = city_de.to_s.gsub(/(,|\/|&|\*|\|| - | or )/, "!@\#$%ˆ&*").split("!@\#$%ˆ&*").map(&:strip)
    cities_en = city_en.to_s.gsub(/(,|\/|&|\*|\|| - | or )/, "!@\#$%ˆ&*").split("!@\#$%ˆ&*").map(&:strip)
    (cities_de << cities_en).flatten!.uniq
  end

  def name_or_email
    fullname.present? ? fullname : email
  end

  def main_topic_or_first_topic
    main_topic.present? ? main_topic : topic_list.first
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidate
    # [:full_name, :id] - you can do this only onUpdate (when :id already set) When you are creating a new record in your DB table this will not work!
    [
      :fullname,
      %i[fullname id]
    ]
  end

  def should_generate_new_friendly_id?
    slug.blank? || firstname_changed? || lastname_changed?
  end

  def website_with_protocol
    if website =~ %r{^https?://}
      website
    else
      'http://' + website
    end
  end

  def twitter_name_formatted
    twitter.gsub(%r{^@|https:|http:|:|//|www.|twitter.com/}, '')
  end

  def twitter_link_formatted
    'http://twitter.com/' + twitter.gsub(%r{^@|https:|http:|:|//|www.|twitter.com/}, '')
  end

  def country_name
    country_name = ISO3166::Country[country]
    country_name.translations[I18n.locale.to_s] || country.name
  end

  def self.random
    order('RANDOM()')
  end

  def update_or_remove_index
    published ? __elasticsearch__.index_document : __elasticsearch__.delete_document
  rescue
    nil
    # rescue a deleted document if not indexed
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

  # for simple admin search
  def self.admin_search(query)
    where("firstname || ' ' || lastname ILIKE :query", query: "%#{query}%")
  end

  def clean_iso_languages!
    iso_languages.reject!(&:empty?)
  end

  # custom validations
  def iso_languages_array_has_right_format
    clean_iso_languages!
    return if iso_languages == []

    if iso_languages.map(&:class).uniq != [String]
      errors.add(:iso_languages, 'must be an array of strings')
    end
    if iso_languages.map(&:size).uniq != [2]
      errors.add(:iso_languages, 'each element must be two charactes')
    end
  end
end
