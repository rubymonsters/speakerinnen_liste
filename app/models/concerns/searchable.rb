module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name [Rails.application.engine_name, Rails.env].join('_')

    def self.search(query)
      __elasticsearch__.search(
        {
          query: {
            multi_match: {
              query: query,
              fields: [
                'firstname^3',
                'twitter^4',
                'topic_list^3',
                'main_topic',
                'languages^2',
                'city',
                'country',
                'bio'
              ],
              tie_breaker: 0.3,
              fuzziness: 'AUTO'
            }
          }
        })
    end


    def as_indexed_json(options={})
      self.as_json(
        only: [:firstname, :lastname, :twitter, :languages, :city],
          methods: [:fullname, :topic_list, :bio, :main_topic],
          include: {
            medialinks: { only: [:title, :description] }
          }
      )
    end

    super_special_settings = {
        index: {
          number_of_shards: 1,
          analysis: {
            char_filter: {
              strip_twitter: {
                type: 'pattern_replace',
                pattern: '[^a-z0-9]',
                replacement: ''
              }
            },
            analyzer:{
              twitter_analyzer: {
                type: 'custom',
                tokenizer: 'keyword',
                filter: ['lowercase'],
                char_filter: ['strip_twitter']
              },
              topic_list_analyzer: {
                type: 'custom',
                tokenizer: 'keyword', # maren: wie soll das matchen? keyword, nicht keyword? evtl booster nutzen
                filter: ['lowercase']
              }
            }
          }
        }
      }

      settings super_special_settings do
        mappings dynamic: 'false' do
          indexes :fullname,   type: 'string', analyzer: 'german'
          indexes :firstname,   type: 'string', analyzer: 'german'
          indexes :lastname,   type: 'string', analyzer: 'german'
          indexes :twitter,    type: 'string', analyzer: 'twitter_analyzer'
          indexes :topic_list, type: 'string', analyzer: 'topic_list_analyzer'
          indexes :main_topic, fields: { english: { type:  'string', analyzer: 'english' }, german: { type:  'string', analyzer: 'german'} }
          indexes :languages,  type: 'string', analyzer: 'standard' # array? german & english drop down!!!
          indexes :city,       type: 'string', analyzer: 'standard' # geodaten??
          indexes :country,    type: 'string', analyzer: 'standard' # not analyzed, iso standard
          indexes :website,    type: 'string', analyzer: 'standard'
          indexes :bio,        fields: { english: { type:  'string', analyzer: 'english' }, german: { type:  'string', analyzer: 'german'} }
          indexes :medialinks, type: 'nested' do
            indexes :title
            indexes :description
          end
        end
      end
  end
end
