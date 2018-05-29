class AddPositionToMedialinks < ActiveRecord::Migration[4.2]
  def change
    add_column :medialinks, :position, :integer
  end
end
