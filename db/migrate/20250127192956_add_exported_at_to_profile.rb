class AddExportedAtToProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :exported_at, :datetime
  end
end
