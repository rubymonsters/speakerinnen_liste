class AddPositionToMedialinks < ActiveRecord::Migration
  def change
    add_column :medialinks, :position, :integer
  end
end
