class CreateMedialinks < ActiveRecord::Migration
  def change
    create_table :medialinks do |t|
      t.belongs_to :profile
      t.text :url
      t.text :title
      t.text :description

      t.timestamps
    end
  end
end
