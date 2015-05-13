module ApplicationHelper
  def devise_mapping
    Devise.mappings[:profile]
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    icon_direction = case sort_direction
      when "asc"  then "up"
      when "desc" then "down"
    end
    tooltip = case column
      when "lastname" then "Nach dem Nachnamen sortieren"
      when "created_at" then "Nach dem Erstellungsdatum sortieren"
      when "updated_at" then "Nach dem letzten Speicherdatum sortieren"
      when "published" then "Nach Sichtbarkeit sortieren"
    end
    direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"
    link_to ("<i class='fa fa-arrow-#{icon_direction}'>&nbsp;</i>").html_safe + title, {sort: column, direction: direction}, data: { toggle: 'tooltip', placement: 'left' }, title: tooltip
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
