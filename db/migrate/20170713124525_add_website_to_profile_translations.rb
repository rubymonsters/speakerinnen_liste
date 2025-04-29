class AddWebsiteToProfileTranslations < ActiveRecord::Migration[7.1]
  def change
    add_column :profile_translations, :website, :string
  end
end