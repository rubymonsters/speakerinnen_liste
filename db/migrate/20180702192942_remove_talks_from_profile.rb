class RemoveTalksFromProfile < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :talks, :string
  end
end
