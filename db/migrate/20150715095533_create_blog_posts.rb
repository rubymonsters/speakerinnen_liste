# frozen_string_literal: true

class CreateBlogPosts < ActiveRecord::Migration[4.2]
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.text :body
      t.string :url
      t.datetime :created_at

      t.timestamps
    end
  end
end
