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
    class: "#{"cat_" + topic.categories.first.short_name if topic.categories.first} btn btn-sm m-1 rounded available-tag sans-serif"
  end

  def profile_picture_link(profile)
    if profile.image.attached?
      link_to(image_tag(profile.image.variant(combine_options: {resize: '300x300^', extent: '300x300', gravity: 'Center'}), class: 'photo--grey'), profile)
    elsif profile.picture.present?
      link_to(image_tag(profile.picture.profile.url, alt: profile.fullname, class: 'photo--grey'), profile)
    else
      link_to(image_tag('avatar.jpg', alt: 'avatar', class: 'photo--grey card-img-top', alt: "Speakerinnen Picture"), profile)
    end
  end

  def topics_for_profile(profile)
    profile.topics.translated_in_current_language_and_not_translated(I18n.locale)
  end
end