module ProfilesHelper
  def can_edit_profile?(current_profile, profile)
    # current_profile is nil if no user is logged in
    if current_profile == profile || (current_profile && current_profile.admin?)
      true
    else
      false
    end
  end

  def topic_link(topic, options={})
    link_to topic.name, topic_path(topic.name), options
  end
end