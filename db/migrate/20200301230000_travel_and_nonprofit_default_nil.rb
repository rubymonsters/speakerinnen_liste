class TravelAndNonprofitDefaultNil < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :willing_to_travel, :boolean
    remove_column :profiles, :nonprofit, :boolean

    add_column :profiles, :willing_to_travel, :boolean, null: true
    add_column :profiles, :nonprofit, :boolean, null: true
  end
end
