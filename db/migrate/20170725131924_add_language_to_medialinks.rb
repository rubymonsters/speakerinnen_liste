class AddLanguageToMedialinks < ActiveRecord::Migration
  def change
    add_column :medialinks, :language, :string
  end
end
