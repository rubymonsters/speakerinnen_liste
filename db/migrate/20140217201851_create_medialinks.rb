class CreateMedialinks < ActiveRecord::Migration
  def change
    create_table :medialinks do |t|
      t.string :link
      t.string :title

      t.timestamps
    end
  end
end
