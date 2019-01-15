# frozen_string_literal: true

class AddTalksToProfile < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :talks, :string
  end
end
