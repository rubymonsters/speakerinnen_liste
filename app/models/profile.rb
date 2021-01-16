# frozen_string_literal: true
class Profile < ApplicationRecord
  include Searchable
  include ActiveModel::Serialization

  has_many :medialinks
  has_many :feature_profiles
  has_many :features, through: :feature_profiles, dependent: :destroy
  has_one_attached :image
  has_and_belongs_to_many :services

  serialize :iso_languages, Array
  validate :iso_languages_array_has_right_format
  validate :image_format_size
  validates :profession, length: { maximum: 60, message: "Please use less than 80 characters." }
  before_save :clean_iso_languages!

  translates :bio, :main_topic, :profession, :twitter, :website, :website_2, :website_3, :city, :personal_note, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  globalize_accessors locales: %i[en de], attributes: %i[main_topic bio profession twitter website website_2 website_3 city personal_note]

  extend FriendlyId
  friendly_id :slug_candidate, use: :slugged

  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  acts_as_taggable_on :topics

  before_save(prepend: %i[create update]) do
    twitter&.gsub(%r{^@|https:|http:|:|//|www.|twitter.com/}, '')
    firstname&.strip!
    lastname&.strip!
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
      new(session['devise.user_attributes']) do |profile|
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
  scope :has_tags, -> (tags) { tagged_with(tags, :any => true) }

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

  def website_with_protocol(profile_website)
    if profile_website =~ %r{^https?://}
      profile_website
    else
      'http://' + profile_website
    end
  end

  def website_in_language_scope(lang, number = '')
    send(('website_' + number + lang.to_s).to_sym)
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
    order(Arel.sql('random()'))
  end

  def update_or_remove_index
    published ? __elasticsearch__.index_document : __elasticsearch__.delete_document
  rescue StandardError
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
    self.includes(taggings: :tag)
    .references(:tag)
    .where("firstname || ' ' || lastname || tags.name ILIKE :query", query: "%#{query}%")
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
  end

  def image_format_size
    if image.attached?
      if image.blob.byte_size > 2.megabyte
        errors.add(:base, :file_size_too_big)
      elsif image.blob.byte_size < 1.byte
        errors.add(:base, :file_size_empty)
      elsif !image.content_type.in?(%w(image/png image/jpg image/jpeg image/gif))
        errors.add(:base, :content_type_invalid)
      end
    end
  end
end
