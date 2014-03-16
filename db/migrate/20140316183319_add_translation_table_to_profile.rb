class AddTranslationTableToProfile < ActiveRecord::Migration
  def up
		Profile.create_translation_table!({
			:main_topic => :string, 
			:bio => :text
		}, {
			:migrate_data => true
		})
  end
	
	def down
		Profile.drop_translation_table! :migrate_data => true
	end

end
