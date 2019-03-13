class CreateFeatureTranslations < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Feature.create_translation_table!({
          :title => :string,
          :description => :text
        }, {
          :migrate_data => true,
          :remove_source_columns => true
        })
      end
    
      dir.down do
        Feature.drop_translation_table! :migrate_data => true
      end
    end
  end
end
