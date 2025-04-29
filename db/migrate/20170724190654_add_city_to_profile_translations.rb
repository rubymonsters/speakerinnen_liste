class AddCityToProfileTranslations < ActiveRecord::Migration[7.1]
  def change
    add_column :profile_translations, :city, :string
  end
end