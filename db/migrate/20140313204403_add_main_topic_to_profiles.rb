class AddMainTopicToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :main_topic, :string
  end
end
