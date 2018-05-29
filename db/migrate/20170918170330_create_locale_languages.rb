class CreateLocaleLanguages < ActiveRecord::Migration[4.2]
  def change
    create_table :locale_languages do |t|
      t.string :iso_code

      t.timestamps
    end
  end
end
