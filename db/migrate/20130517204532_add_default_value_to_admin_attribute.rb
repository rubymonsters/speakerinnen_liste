class AddDefaultValueToAdminAttribute < ActiveRecord::Migration
	def change
    change_column :profiles, :admin, :default => false
  end
end
