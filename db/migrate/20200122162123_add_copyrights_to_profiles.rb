class AddCopyrightsToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :copyright, :string
  end
end
