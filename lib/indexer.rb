class Indexer
  include Elasticsearch::Model

  class << self
    def perform(model)
      # controlling the 'knowledge' of what should be imported in separate class
      Profile.table_name
      Profile.import force: true, scope: 'published'
    end
  end
end
