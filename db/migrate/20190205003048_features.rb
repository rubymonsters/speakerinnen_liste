class Features < ActiveRecord::Migration[5.2]
  def change
    create_table :features do |t|
      t.integer :position
      t.boolean :public

      t.timestamps
    end
  end
end
