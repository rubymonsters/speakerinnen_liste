class RemoveTopicsFromProfiles < ActiveRecord::Migration
  def up
    remove_column :profiles, :topics
  end

  def down
    add_column :profiles, :topics, :string
  end
end
