class CreateApiToken < ActiveRecord::Migration[4.2]
  def change
    create_table :api_tokens do |t|
      t.string :name
      t.string :token
    end
  end
end
