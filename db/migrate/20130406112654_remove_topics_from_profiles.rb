class RemoveTopicsFromProfiles < ActiveRecord::Migration[4.2]
  def up
    remove_column :profiles, :topics
  end

  def down
    add_column :profiles, :topics, :string
  end
end
