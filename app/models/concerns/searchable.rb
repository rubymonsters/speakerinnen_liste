module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
  end

  def as_indexed_json(options={})
      self.as_json(
        only: [:firstname, :lastname, :twitter, :fullname],
          methods: [:fullname, :topic_list, :bio, :main_topic],
        include: {
          medialinks: { only: [:title, :url] }
        }
      )
    end
end
