class AddProfessionToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :profession, :string
  end
end
