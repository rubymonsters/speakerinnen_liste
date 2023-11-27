# frozen_string_literal: true

class Medialink < ApplicationRecord
  belongs_to :profile

  validates :title, :url, presence: true

  def youtube_thumbnail_url
    youtube_id = find_youtube_id
    return unless youtube_id

    "https://img.youtube.com/vi/" + youtube_id + "/mqdefault.jpg"
  end

  def find_youtube_id
    id = url.match(/((?<=v=)|(?<=youtu.be\/)).+/)
    id ? id[0].split(/(\?|&)/).first : nil
  end
end
