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
    link_to("<i class='fa fa-arrow-#{icon_direction}'>&nbsp;</i>".html_safe + title, { sort: column, direction: direction }, data: { toggle: 'tooltip', placement: 'left' }, title: tooltip)
  end

  def custom_tag_cloud(tags, classes)
    return [] if tags.empty?

    max_count = tags.sort_by { |t| t.taggings.count }.last.taggings.count.to_f

    tags.each do |tag|
      index = ((tag.taggings.count / max_count) * (classes.size - 1))
      yield tag, classes[index.nan? ? 0 : index.round]
    end
  end
end
