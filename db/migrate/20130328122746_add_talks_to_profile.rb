class AddTalksToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :talks, :string
  end
end
