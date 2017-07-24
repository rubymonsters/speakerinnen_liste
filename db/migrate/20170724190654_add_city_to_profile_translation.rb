class AddCityToProfileTranslation < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Profile.add_translation_fields!({city: :string}, {:migrate_data => true})
      end

      dir.down do
        remove_column :profile_translations, :city
      end
    end
  end
end
