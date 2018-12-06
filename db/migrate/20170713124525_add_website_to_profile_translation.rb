class AddWebsiteToProfileTranslation < ActiveRecord::Migration[4.2]
  def change
    reversible do |dir|
      dir.up do
        Profile.add_translation_fields!({website: :string}, {:migrate_data => true})
      end

      dir.down do
        remove_column :profile_translations, :website
      end
    end
  end
end
