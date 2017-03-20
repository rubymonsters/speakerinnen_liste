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
                'fullname',
                'twitter',
                'topic_list',
                'bio_en',
                'bio_de',
                'main_topic_en',
                'main_topic_de',
                'languages',
                'city',
                'country'              ],
              tie_breaker: 0.3,
              fuzziness: 'AUTO'
            }
          },
          aggs: {
            lang: {
              terms: {
                field: "languages"
              }
            },
            city: {
              terms: {
                field: "city"
              }
            }
          }
        })
    end

    def as_indexed_json(options={})
      self.as_json(
        only: [:firstname, :lastname, :twitter, :languages, :city, :country],
          methods: [:fullname, :topic_list, *globalize_attribute_names],
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

    ANALYZERS = { de: 'german', en: 'english' }

    settings super_special_settings do
      mappings dynamic: 'false' do
        indexes :fullname,   type: 'string', analyzer: 'german'
        indexes :twitter,    type: 'string', analyzer: 'twitter_analyzer'
        indexes :topic_list, type: 'string', analyzer: 'topic_list_analyzer'
        I18n.available_locales.each do |locale|
          [:main_topic, :bio].each do |name|
            indexes :"#{name}_#{locale}", type: 'string', analyzer: ANALYZERS[locale]
          end
        end
        indexes :languages,  type: 'string', analyzer: 'standard' # array? german & english drop down!!!
        indexes :city,       type: 'string', analyzer: 'standard', 'norms': { 'enabled': false }
        indexes :country,    type: 'string', analyzer: 'standard' # iso standard
        indexes :website,    type: 'string', analyzer: 'standard'
        indexes :medialinks, type: 'nested' do
          indexes :title
          indexes :description
        end
      end
    end
  end
end
