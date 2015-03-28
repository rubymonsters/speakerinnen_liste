class PagesController < ApplicationController

  def home
    @profiles = Profile.is_published.random.limit(8)
    @categories = Category.order(:name).all
  end

  def render_footer?
    true
  end

  private

  def first_in_collection
    @profiles.first?
  end

  def last_in_collection
    @profiles.last?
  end
end
