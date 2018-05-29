class AddDefaultValueToAdminAttribute < ActiveRecord::Migration[4.2]
	def up
    change_column :profiles, :admin, :boolean, :default => false
	end

	def down
    change_column :profiles, :admin, :boolean, :default => nil
	end
end
