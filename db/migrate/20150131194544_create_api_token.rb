class CreateApiToken < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.string :name
      t.string :token
    end
  end
end
