# frozen_string_literal: true

class Medialink < ApplicationRecord
  belongs_to :profile

  validates :title, :url, presence: true

  def youtube_thumbnail_url
    "https://img.youtube.com/vi/" + find_youtube_id + "/default.jpg"
  end

  def find_youtube_id
    url.match(/((?<=v=)|(?<=youtu.be\/))\w+/)[0]
  end
end
