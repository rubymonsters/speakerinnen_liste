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

  def top_link(params)
    link_to t(:adapt_search, scope: 'search'), profiles_path + "?utf8=✓&utf8=✓&search=#{params}&button=/#top"
  end

  def topic_link(topic, options = {})
    link_to topic, topic_path(topic: topic.to_s), options
  end

  def profile_picture_link(profile)
    if profile.picture.present?
      link_to(image_tag(profile.picture.profile.url, alt: profile.fullname, class: 'photo--grey'), profile)
    else
      link_to(image_tag('avatar.jpg', alt: 'avatar', class: 'photo--grey'), profile)
    end
  end

  def topics(profile)
    topics = []
    topics << profile.topics.with_language(I18n.locale)
    topics << profile.topics.without_language
    topics = topics.flatten.uniq
  end
end
