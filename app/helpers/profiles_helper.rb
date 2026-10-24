# frozen_string_literal: true

module ProfilesHelper
  def can_edit_profile?(current_profile, profile)
    # current_profile is nil if no user is logged in
    if current_profile == profile || (current_profile&.admin?)
      true
    else
      false
    end
  end

  def topic_link(topic, options = {})
    link_to topic, topic_path(topic: topic.to_s), options
  end

  def topic_link_color(topic)
    link_to topic, topic_path(topic: topic.to_s), id: topic.name.gsub(/\s+/, "-"),
    class: "#{"bg-" + topic.categories.first.slug if topic.categories.first} btn btn-sm m-1 sans-serif tag-button"
  end

  def profile_image_link(profile)
    if Rails.env.development?
      return link_to(image_tag('avatar.png', alt: 'avatar', class: 'photo--grey card-img-top'), profile, class: "p-0")
    end

    if profile.image.attached?
      link_to(image_tag(profile.image.variant(resize_to_fill: [600, 600]), class: 'photo--grey'), profile, class: "p-0")
    else
      link_to(image_tag('avatar.png', alt: 'avatar', class: 'photo--grey card-img-top'), profile, class: "p-0")
    end
  end

  def topics_for_profile(profile)
    profile.topics.translated_in_current_language_and_not_translated(I18n.locale)
  end

  def disable_contact_button(profile)
    'style=display:none' if profile.id == 309
  end

  SOCIAL_MEDIA_ICONS = {
    instagram: 'fa-brands fa-instagram',
    linkedin: 'fa-brands fa-linkedin',
    bluesky: 'fa-solid fa-cloud', # Bluesky has no official icon yet
    mastodon: 'fa-brands fa-mastodon'
  }.freeze

  # "Berlin · German and English", or only the part that is filled in
  def profile_intro(profile)
    parts = []
    parts << content_tag(:strong, profile.city) if profile.city.present?
    if profile.iso_languages.present?
      parts << to_sentence(profile.iso_languages.map { |iso| content_tag(:strong, t(iso, scope: 'iso_639_1').capitalize) })
    end
    safe_join(parts, ' · ') if parts.any?
  end

  # websites in the current language, or all websites with fallback if none is translated
  def profile_websites(profile)
    translated = ['', '2_', '3_'].map { |number| profile.website_in_language_scope(I18n.locale, number) }
    websites = translated.any?(&:present?) ? translated : [profile.website, profile.website_2, profile.website_3]
    websites.select(&:present?)
  end

  def profile_social_media_links(profile)
    SOCIAL_MEDIA_ICONS.filter_map do |network, icon|
      url = profile.public_send(network)
      [url, icon] if url.present?
    end
  end
end
