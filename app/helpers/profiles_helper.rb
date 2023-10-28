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
    class: "#{"bg-" + topic.categories.first.short_name if topic.categories.first} btn btn-sm m-1 sans-serif tag-button"
  end

  def profile_image_link(profile)
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
end
