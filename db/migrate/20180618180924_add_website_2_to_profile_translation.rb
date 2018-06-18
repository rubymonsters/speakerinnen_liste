class AddWebsite2ToProfileTranslation < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Profile.add_translation_fields!({website_2: :string})
      end

      dir.down do
        remove_column :profile_translations, :website_2
      end
    end
  end
end
