module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name [Rails.application.engine_name, Rails.env].join('_')

    def self.search(query, options={})
      __elasticsearch__.search(query, options)
    end

    def as_indexed_json(options={})
      self.as_json(
        only: [:firstname, :lastname, :twitter],
          methods: [:fullname, :topic_list, :bio, :main_topic],
        include: {
          medialinks: { only: [:title, :url] }
        }
      )
    end
  end
end
