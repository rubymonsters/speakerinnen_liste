class AddProfessionToProfile < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Profile.add_translation_fields!({profession: :string}, {:migrate_data => true})
      end

      dir.down do
        remove_column :profile_translations, :profession
      end
    end
  end
end

