# frozen_string_literal: true

class Medialink < ApplicationRecord
  include AutoHtml

  belongs_to :profile

  validates :title, :url, presence: true

  auto_html_for :url do
    html_escape
    image
    youtube width: 400, height: 250
    vimeo width: 400, height: 250
    simple_format
    link target: '_blank', rel: 'nofollow'
  end
end
