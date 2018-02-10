class RemoveCityFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :city, :string
  end
end
