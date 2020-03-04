class AddPersonalNoteToProfileTranslation < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Profile.add_translation_fields!({personal_note: :string})
      end

      dir.down do
        remove_column :profile_translations, :personal_note
      end
    end
  end
end
