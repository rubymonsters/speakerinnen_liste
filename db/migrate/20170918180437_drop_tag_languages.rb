class DropTagLanguages < ActiveRecord::Migration
  def up
    drop_table :tag_languages
  end
end
