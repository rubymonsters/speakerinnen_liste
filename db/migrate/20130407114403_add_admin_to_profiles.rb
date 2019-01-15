# frozen_string_literal: true

class AddAdminToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :admin, :boolean
  end
end
