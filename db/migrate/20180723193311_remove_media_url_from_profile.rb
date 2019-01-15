# frozen_string_literal: true

class RemoveMediaUrlFromProfile < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :media_url, :string
  end
end
