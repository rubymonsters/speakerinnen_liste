class AddTwitterToProfileTranslations < ActiveRecord::Migration[7.1]
  def change
    add_column :profile_translations, :twitter, :string
  end
end