class CreateLocaleLanguages < ActiveRecord::Migration
  def change
    create_table :locale_languages do |t|
      t.string :iso_code

      t.timestamps
    end
  end
end
