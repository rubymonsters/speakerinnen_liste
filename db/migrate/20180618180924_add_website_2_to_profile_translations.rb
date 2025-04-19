class AddWebsite2ToProfileTranslations < ActiveRecord::Migration[7.1]
  def change
    add_column :profile_translations, :website_2, :string
  end
end

    
