class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :featured_profiles, :profile_ids, :profile_names
  end
end
