class RemoveUsers < ActiveRecord::Migration
  def up
    # drop_table(:users) rescue nil
  end

  def down
    raise "Sorry this migration is not meant to be"
  end
end
