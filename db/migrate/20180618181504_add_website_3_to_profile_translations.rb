class AddWebsite3ToProfileTranslations < ActiveRecord::Migration[7.1]
  def change
    add_column :profile_translations, :website_3, :string
  end
end
