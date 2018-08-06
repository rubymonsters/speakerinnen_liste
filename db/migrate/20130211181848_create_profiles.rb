class CreateProfiles < ActiveRecord::Migration[4.2]
  def change
    create_table :profiles do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.text :bio
      t.string :topics
      t.string :languages
      t.string :city
      t.string :twitter
      t.string :picture

      t.timestamps
    end
  end
end
