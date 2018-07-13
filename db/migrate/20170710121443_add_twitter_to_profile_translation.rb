class AddTwitterToProfileTranslation < ActiveRecord::Migration[4.2]
    def change
    reversible do |dir|
      dir.up do
        Profile.add_translation_fields!({twitter: :string}, {:migrate_data => true})
      end

      dir.down do
        remove_column :profile_translations, :twitter
      end
    end
  end
end
