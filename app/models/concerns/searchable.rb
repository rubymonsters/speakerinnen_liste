module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name [Rails.application.engine_name, Rails.env].join('_')

    def self.search(query)
      __elasticsearch__.search(
        {
          min_score: 0.5,
          query: {
            multi_match: {
              query: query,
              fields: [
                'fullname^1.5',
                'twitter',
                'topic_list',
                'bio_en',
                'bio_de',
                'main_topic_en',
                'main_topic_de',
                # 'split_languages',
                'cities.standard^1.5',
                'country'
              ],
              tie_breaker: 0.3,
              fuzziness: 'AUTO'
            }
          },
          aggs: {
            lang: {
              terms: {
                field: "split_languages"
              }
            },
            city: {
              terms: {
                field: "cities.unmod"
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
            synonym_filter: {
              type: 'synonym',
              synonyms: [
                "phd,dr.,dr"
              ]
            },
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
              tokenizer: 'keyword',
              filter: ['lowercase']
            },
            # elisions????
            cities_analyzer: {
              type: 'custom',
              tokenizer: 'keyword',
              filter: ['lowercase']
            },
            fullname_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: [
                'lowercase',
                'synonym_filter'
              ]
            },
            english_without_stemming: {
              tokenizer:  'standard',
              filter: [
                'english_possessive_stemmer',
                'lowercase',
                'english_stop',
                'synonym_filter'
              ]
            },
            german_without_stemming: {
              tokenizer:  'standard',
              filter: [
                'lowercase',
                'german_stop',
                'german_normalization',
                'synonym_filter'
              ]
            }
          }
        }
      }
    }

    ANALYZERS = { de: 'german', en: 'english' }

    settings super_special_settings do
      mappings dynamic: 'false' do
        indexes :fullname,   type: 'string', analyzer: 'fullname_analyzer'
        indexes :twitter,    type: 'string', analyzer: 'twitter_analyzer'
        indexes :topic_list, type: 'string', analyzer: 'topic_list_analyzer'
        I18n.available_locales.each do |locale|
          [:main_topic, :bio].each do |name|
            indexes :"#{name}_#{locale}", type: 'string', analyzer: "#{ANALYZERS[locale]}_without_stemming"
          end
        end
        indexes :split_languages,   type: 'string', analyzer: 'standard', 'norms': { 'enabled': false } # iso standard
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
