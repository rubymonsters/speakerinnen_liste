class Profile < ApplicationRecord
  include PgSearch::Model
  include ActiveModel::Serialization

  # Matching and ranking both run off the stored `searchable` column, which is
  # GIN-indexed. `against` is only here because pg_search requires it; the listed
  # columns are not read once tsvector_column is set.
  pg_search_scope :search,
    against: %i[firstname lastname],
    using: {
      tsearch: { prefix: true, tsvector_column: 'searchable' }
    }

  # Mirrors the tsvector pg_search used to build inline on every query, with the
  # same weights. Kept as one expression so it can run as a set-based UPDATE.
  SEARCH_VECTOR_SQL = <<~SQL.squish.freeze
    setweight(to_tsvector('simple', coalesce(profiles.firstname, '')), 'A') ||
    setweight(to_tsvector('simple', coalesce(profiles.lastname, '')), 'A') ||
    setweight(to_tsvector('simple', coalesce(profiles.state, '')), 'C') ||
    setweight(to_tsvector('simple', coalesce(profiles.country, '')), 'C') ||
    setweight(to_tsvector('simple', coalesce((SELECT string_agg(pt.bio, ' ')
      FROM profile_translations pt WHERE pt.profile_id = profiles.id), '')), 'C') ||
    setweight(to_tsvector('simple', coalesce((SELECT string_agg(pt.city, ' ')
      FROM profile_translations pt WHERE pt.profile_id = profiles.id), '')), 'B') ||
    setweight(to_tsvector('simple', coalesce((SELECT string_agg(pt.main_topic, ' ')
      FROM profile_translations pt WHERE pt.profile_id = profiles.id), '')), 'A') ||
    setweight(to_tsvector('simple', coalesce((SELECT string_agg(t.name, ' ')
      FROM taggings tg JOIN tags t ON t.id = tg.tag_id
      WHERE tg.taggable_id = profiles.id AND tg.taggable_type = 'Profile'
        AND tg.context = 'topics'), '')), 'A')
  SQL

  def self.refresh_search_vectors(ids = nil)
    scope = ids ? where(id: ids) : all
    scope.unscope(:select, :order, :includes, :limit).update_all("searchable = #{SEARCH_VECTOR_SQL}")
  end

  # Facet filters. The values come straight from the aggregation buckets in
  # ProfileGrouper, so these are structural matches, not ranked full-text search.
  scope :by_country, ->(country) { where(country: country) }
  scope :by_state, ->(state) { where(state: state) }
  scope :by_language, ->(language) { where('iso_languages LIKE ?', "%\n- #{language}\n%") }
  scope :by_city, lambda { |city|
    where(id: Profile::Translation.where('city ~* ?', "\\m#{escape_posix_regexp(city)}\\M").select(:profile_id))
  }

  def self.escape_posix_regexp(string)
    string.to_s.gsub(/[\\^$.\[\]|()*+?{}]/) { |char| "\\#{char}" }
  end

  has_many :medialinks
  has_many :feature_profiles
  has_many :features, through: :feature_profiles, dependent: :destroy
  has_one_attached :image
  has_and_belongs_to_many :services

  serialize :iso_languages, type: Array, coder: YAML
  validate :iso_languages_array_has_right_format
  validate :image_format_size
  validates :profession, length: { maximum: 60, message: "Please use less than 80 characters." }
  validates :instagram, :linkedin, :bluesky, :mastodon, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true
  before_save :clean_iso_languages!

  extend Mobility
  translates :bio, :main_topic, :profession, :twitter, :website, :website_2, :website_3, :city, :personal_note

  extend FriendlyId
  friendly_id :slug_candidate, use: :slugged

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  acts_as_taggable_on :topics

  # after_save_commit, so translations (autosaved by Mobility) and taggings
  # (written in acts_as_taggable_on's own after_save) are already persisted.
  after_save_commit { self.class.refresh_search_vectors(id) }

  before_save(prepend: %i[create update]) do
    twitter&.gsub(%r{^@|https:|http:|:|//|www.|twitter.com/}, '')
    firstname&.strip!
    lastname&.strip!
  end

  def after_confirmation
    AdminMailer.new_profile_confirmed(self).deliver_now
  end

  def self.by_region(region)
    region = :'upper-austria' if region == :ooe
  	region ? where('country = ? OR state = ?', region, region) : all
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
  scope :not_exported, -> { where(exported_at: nil) }

  # only show profile where the main_topic is filled in in the current locale
  scope :main_topic_translated_in, ->(locale) {
    joins('INNER JOIN profile_translations ON profile_translations.profile_id = profiles.id')
      .where('profile_translations.locale' => locale)
      .where.not('profile_translations.main_topic' => [nil, ''])
  }

  def self.typeahead(term, region: nil)
    profiles =
      Profile
          .by_region(region)
          .is_published
          .with_attached_image
          .includes(:taggings, :topics, :translations)
          .distinct

    firstnames = profiles.where('firstname ILIKE ?', "%#{term}%").map(&:fullname)
    lastnames = profiles.where('lastname ILIKE ?', "%#{term}%").map(&:fullname)
    tags = profiles.tag_counts_on(:topics).where('name ILIKE ?', "%#{term}%").pluck(:name)
    main_topics = profiles.where('main_topic ILIKE ?', "%#{term}%").pluck(:main_topic)

    suggestions = firstnames + lastnames + tags + main_topics
    suggestions.map { |s| s.downcase }.uniq
  end

  Struct.new(
    'ProfileCardDetails',
    :id,
    :fullname,
    :iso_languages,
    :city,
    :willing_to_travel,
    :nonprofit,
    :main_topic,
    keyword_init: true
  )

  def profile_card_details
    Struct::ProfileCardDetails.new(
      id: id,
      fullname: fullname,
      iso_languages: iso_languages,
      city: city,
      willing_to_travel: willing_to_travel,
      nonprofit: nonprofit,
      main_topic: main_topic,
    )
  end

  def fullname
    "#{firstname} #{lastname}".strip
  end

  def cities
    cities_de = Mobility.with_locale(:de) { city.to_s }
      .gsub(/(,|\/|&|\*|\|| - | or )/, "!@\#$%ˆ&*")
      .split("!@\#$%ˆ&*")
      .map(&:strip)
  
    cities_en = Mobility.with_locale(:en) { city.to_s }
      .gsub(/(,|\/|&|\*|\|| - | or )/, "!@\#$%ˆ&*")
      .split("!@\#$%ˆ&*")
      .map(&:strip)
  
    (cities_de + cities_en).uniq
  end

  def region
    state
  end

  def name_or_email
    fullname.present? ? fullname : email
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

  def website_in_language_scope(lang, number = '')
    send(('website_' + number + lang.to_s).to_sym)
  end

  def twitter_name_formatted
    twitter.gsub(%r{^@|https:|http:|:|//|www.|twitter.com/}, '')
  end

  def twitter_link_formatted
    'https://twitter.com/' + twitter.gsub(%r{^@|https:|http:|:|//|www.|twitter.com/}, '')
  end

  def country_name
    country_name = ISO3166::Country[country]
    country_name.translations[I18n.locale.to_s] || country.name
  end

  def self.random
    order(Arel.sql('random()'))
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
    self
    .where("firstname || ' ' || lastname || email ILIKE :query", query: "%#{query}%")
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
