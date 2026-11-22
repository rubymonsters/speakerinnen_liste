class CreateSharepics < ActiveRecord::Migration[8.1]
  def change
    create_table :sharepics do |t|
      t.string :title, null: false
      t.text :description
      t.integer :position, null: false, default: 0
      t.boolean :published, null: false, default: true

      t.timestamps
    end

    add_index :sharepics, %i[published position]
  end
end
