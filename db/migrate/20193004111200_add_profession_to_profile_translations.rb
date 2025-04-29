class AddProfessionToProfileTranslations < ActiveRecord::Migration[7.1]
  def change
    add_column :profile_translations, :profession, :string
  end
end

