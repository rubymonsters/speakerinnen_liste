class AddPersonalNoteToProfileTranslations < ActiveRecord::Migration[7.1]
  def change
    add_column :profile_translations, :personal_note, :string 
  end
end
