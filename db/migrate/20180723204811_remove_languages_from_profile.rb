class RemoveLanguagesFromProfile < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :languages, :string
  end
end
