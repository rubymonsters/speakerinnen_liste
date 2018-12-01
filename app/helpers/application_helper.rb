# frozen_string_literal: true

module ApplicationHelper
  def devise_mapping
    Devise.mappings[:profile]
  end

  def sortable(column, title = nil)
    title ||= column.titleize

    direction_mapping = {
      'asc' => 'up',
      'desc' => 'down'
    }
    icon_direction = direction_mapping[sort_direction]

    tooltip_mapping = {
      'lastname' => 'Nach dem Nachnamen sortieren',
      'created_at' => 'Nach dem Erstellungsdatum sortieren',
      'updated_at' => 'Nach dem letzten Speicherdatum sortieren',
      'published' => 'Nach Sichtbarkeit sortieren'
    }
    tooltip = tooltip_mapping[column]
    
    direction = column == sort_column && sort_direction == 'desc' ? 'asc' : 'desc'
    arrow = column == sort_column ? "<i class='fa fa-arrow-#{icon_direction}'>&nbsp;</i>".html_safe : ""
    link_to(arrow + title, { sort: column, direction: direction }, data: { toggle: 'tooltip', placement: 'left' }, title: tooltip)
  end

  def custom_tag_cloud(tags, classes)
    return [] if tags.empty?

    max_count = tags.pluck(:taggings_count).max.to_f

    tags.each do |tag|
      index = ((tag.taggings.count / max_count) * (classes.size - 1))
      yield tag, classes[index.nan? ? 0 : index.round]
    end
  end
end
