class AddMainTopicToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :main_topic, :string
  end
end
