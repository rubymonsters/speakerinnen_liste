class CreateBlogPosts < ActiveRecord::Migration
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
