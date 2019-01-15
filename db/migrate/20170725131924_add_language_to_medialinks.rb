# frozen_string_literal: true

class AddLanguageToMedialinks < ActiveRecord::Migration[4.2]
  def change
    add_column :medialinks, :language, :string
  end
end
