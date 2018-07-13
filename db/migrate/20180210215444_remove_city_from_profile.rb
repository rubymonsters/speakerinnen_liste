class RemoveCityFromProfile < ActiveRecord::Migration[4.2]
  def change
    remove_column :profiles, :city, :string
  end
end
