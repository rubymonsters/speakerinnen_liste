# frozen_string_literal: true

class AddMediaUrlToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :media_url, :string
  end
end
