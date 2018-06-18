# frozen_string_literal: true

class Indexer
  include Elasticsearch::Model

  class << self
    def perform(_model)
      # controlling the 'knowledge' of what should be imported in separate class
      Profile.table_name
      Profile.import force: true, scope: 'is_published'
    end
  end
end
