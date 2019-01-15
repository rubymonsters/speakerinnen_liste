# frozen_string_literal: true

class RemoveWebsiteFromProfile < ActiveRecord::Migration[4.2]
  def change
    remove_column :profiles, :website, :string
  end
end
