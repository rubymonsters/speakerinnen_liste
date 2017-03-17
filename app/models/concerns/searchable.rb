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
                'country'
              ],
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
      as_json(
        # change city to cities (list)
        {
        only: [:firstname, :lastname, :twitter, :languages, :city, :country],
          methods: [:fullname, :topic_list, :cities, :split_languages, *globalize_attribute_names],
          include: {
            medialinks: { only: [:title, :description] }
          }
        }
       )
    end

    super_special_settings = {
      index: {
        number_of_shards: 1,
        analysis: {
          filter: {
            english_stop: {
              type:       'stop',
              stopwords:  '_english_' 
            },
            english_possessive_stemmer: {
              type:       'stemmer',
              language:   'possessive_english'
            },
            german_stop: {
              type:       'stop',
              stopwords:  '_german_' 
            }
          },
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
            },
            # elisions????
            cities_analyzer: {
              type: 'custom',
              tokenizer: 'keyword',
              filter: ['lowercase']
            },
            english_without_stemming: {
              tokenizer:  'standard',
              filter: [
                'english_possessive_stemmer',
                'lowercase',
                'english_stop'
              ]
            },
            german_without_stemming: {
              tokenizer:  'standard',
              filter: [
                'lowercase',
                'german_stop',
                'german_normalization'
              ]
            }
          }
        }
      }
    }

    ANALYZERS = { de: 'german', en: 'english' }

    settings super_special_settings do
      mappings dynamic: 'false' do
        indexes :fullname,   type: 'string', analyzer: 'standard'
        indexes :twitter,    type: 'string', analyzer: 'twitter_analyzer'
        indexes :topic_list, type: 'string', analyzer: 'topic_list_analyzer'
        I18n.available_locales.each do |locale|
          [:main_topic, :bio].each do |name|
            indexes :"#{name}_#{locale}", type: 'string', analyzer: ANALYZERS[locale]
          end
        end
        indexes :languages,  type: 'string', analyzer: 'standard' # array? german & english drop down!!!
        indexes :split_languages,   type: 'string', analyzer: 'standard', 'norms': { 'enabled': false }
        indexes :cities, fields: { unmod: { type:  'string', analyzer: 'cities_analyzer' }, standard: { type:  'string', analyzer: 'standard'} }
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
