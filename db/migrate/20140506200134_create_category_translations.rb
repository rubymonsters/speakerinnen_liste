class CreateCategoryTranslations < ActiveRecord::Migration[7.1]
  def change
    create_table :category_translations do |t|
      t.references :category, null: false, foreign_key: true
      t.string :locale, null: false

      t.string :name

      t.timestamps
    end

    add_index :category_translations, [:category_id, :locale], unique: true
  end
end
