class AddWebsite3ToProfileTranslation < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Profile.add_translation_fields!({website_3: :string})
      end

      dir.down do
        remove_column :profile_translations, :website_3
      end
    end
  end
end
