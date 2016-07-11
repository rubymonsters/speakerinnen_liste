class PagesController < ApplicationController
  def home
    @profiles   = Profile.is_published.random.limit(8)
    @categories = Category.sorted_categories
    @blog_posts = BlogPost.order('created_at DESC').limit(2)
  end

  def render_footer?
    true
  end
end
