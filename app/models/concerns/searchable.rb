module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name [Rails.application.engine_name, Rails.env].join('_')

    # def self.typeahead(q)
    #   self.__elasticsearch__.client.suggest(index: self.index_name, body: {
    #     fullname_suggest:{
    #       text: q,
    #       completion: {
    #         field: "fullname_suggest"
    #       }
    #     }
    #   })
    # end

    def self.search(query)
      __elasticsearch__.search(
# stadt heraustrennen? allen den gleichen score dafür geben, keine kombination
# fuzziness turned off?
# norms disabled everywhere?

        {
          # minimum score depends completely on the given data and query, find out what works in your case.
          min_score: 0.3, # this makes index creation on tests fail :(
          query: {
            multi_match: {
              query: query,
              # term-centric approach. First analyzes the query string into individual terms, then looks for each term in any of the fields, as though they were one big field.
              type: 'cross_fields', # i don't understand this
              fields: [
                'fullname^1.5',
                'twitter',
                'topic_list',
                'bio_en',
                'bio_de',
                'main_topic_en',
                'main_topic_de',
                'split_languages',
                'cities.standard^1.5',
                'country'
              ],
              tie_breaker: 0.3,
              minimum_should_match: "50%"
              # fuzziness: 'AUTO'
            }
          },
          # for autocompletion
          suggest: {
            fullname_suggest: {
              text: query,
              completion: {
                field: "fullname"
              }
            }
          },
          # # for autocompletion
          # suggest: {
          #   suggestion: {
          #     text: query,
          #     term: {
          #       field: "fullname"
          #     }
          #   }
          # },
          # # for autocompletion
          # suggest: {
          #   profiles: {
          #     text: query,
          #     completion: { field: "fullname_suggest"}
          #   }
          # },
          # _source: ['fullname', 'firstname'],
          # aggregation, will be used for faceted search
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
        {
        fullname_suggest: { input:  fullname },
        only: [:firstname, :lastname, :twitter, :languages, :city, :country],
          methods: [:fullname, :topic_list, :cities, :split_languages, *globalize_attribute_names],
          include: {
            medialinks: { only: [:title, :description] }
          }
        }
       )
    end


# elisions????
# add to cities and topic_list and main_topic

# TO DO 
# Write comments
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
            language_synonyms: {
              type: 'synonym',
              synonyms: Rails.configuration.elasticsearch_language_synonyms
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
              filter: ['asciifolding', 'lowercase']
            },
            cities_analyzer: {
              type: 'custom',
              tokenizer: 'keyword',
              filter: ['asciifolding', 'lowercase']
            },
            fullname_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: [
                'asciifolding',
                'lowercase',
                'synonym_filter'
              ]
            },
            language_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: [
                'lowercase',
                'language_synonyms'
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
        # },
        # suggest: {
        #   term: {
        #     field: "fullname"
        #   }
          # type: "completion",
          # analyzer: "simple",
          # search_analyzer: "simple",
          # payloads: "true"
        }
      }
    }

    ANALYZERS = { de: 'german', en: 'english' }

    settings super_special_settings do
      mappings dynamic: 'false' do
        # indexes :fullname,   type: 'string', analyzer: 'fullname_analyzer',   'norms': { 'enabled': false }
        # indexes :fullname_suggest, type: 'completion', analyzer: 'fullname_analyzer', payloads: false
        # indexes :fullname_suggest, type: 'completion', index_analyzer: 'fullname_analyzer', search_analyzer: 'fullname_analyzer', payloads: false
        indexes :fullname,   type: 'string', analyzer: 'fullname_analyzer',   'norms': { 'enabled': false } do
          indexes :suggest,  type: 'completion'
        end
        indexes :twitter,    type: 'string', analyzer: 'twitter_analyzer',    'norms': { 'enabled': false }
        indexes :topic_list, type: 'string', analyzer: 'topic_list_analyzer', 'norms': { 'enabled': false }
        I18n.available_locales.each do |locale|
          [:main_topic, :bio].each do |name|
            indexes :"#{name}_#{locale}", type: 'string', analyzer: "#{ANALYZERS[locale]}_without_stemming"
          end
        end
        indexes :split_languages,   type: 'string', analyzer: 'language_analyzer', 'norms': { 'enabled': false }
        indexes :cities, fields: { unmod: { type:  'string', analyzer: 'cities_analyzer', 'norms': { 'enabled': false } }, standard: { type:  'string', analyzer: 'standard', 'norms': { 'enabled': false }} }
        indexes :country,    type: 'string', analyzer: 'standard', 'norms': { 'enabled': false }
        indexes :website,    type: 'string', analyzer: 'standard', 'norms': { 'enabled': false }
        indexes :medialinks, type: 'nested' do
          indexes :title, 'norms': { 'enabled': false }
          indexes :description, 'norms': { 'enabled': false }
        end
      end
    end

    def fullname_suggest
      {
        # input: keywords.map { |k| k.keyword.downcase }
        input: fullnames.map { |f| f.fullname.downcase }
      }
    end

  end
end

#term suggester, did you mean
# suggester sind besser als fuzziness. 
