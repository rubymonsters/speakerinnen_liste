module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name [Rails.application.engine_name, Rails.env].join('_')

    def self.search(query, filter_cities, filter_lang)
      @filter_cities = filter_cities
      @filter_lang = filter_lang
      puts "*******************"
      puts "search: #{query}"
      puts "filter cities: #{@filter_cities}"
      puts "filter lang: #{@filter_lang}"
      puts "*******************"
      query_hash =
        {
          # minimum score depends completely on the given data and query, find out what works in your case.
          # min_score: 0.15, # this makes index creation on tests fail :(
          min_score: 0.14, # this makes index creation on tests fail :(
          # min_score: 0.001, # this makes index creation on tests fail :(
          explain: true,
          query: {
            bool: {
              should: [
                {
                  multi_match: {
                    query: query,
                    # term-centric approach. First analyzes the query string into individual terms, then looks for each term in any of the fields, as though they were one big field.
                    type: 'cross_fields',
                    fields: [
                      'fullname^1.7',
                      'twitter',
                      'split_languages',
                      'cities.standard^1.3',
                      'country',
                      'topic_list^1.4',
                      'main_topic_en^1.6',
                      'main_topic_de^1.6'
                    ],
                    tie_breaker: 0.3,
                    minimum_should_match: '76%'
                  }
                },
                {
                  multi_match: {
                    query: query,
                    # field-centric approach.
                    type: 'best_fields',
                    fields: [
                      'bio_en^0.8',
                      'bio_de^0.8'
                    ],
                    tie_breaker: 0.3,
                  }
                }
              ]
            }
          },
          # suggester for zero matches
          suggest: {
            did_you_mean_fullname: {
              text: query,
              term: {
                field: 'fullname'
              }
            # },
            # did_you_mean_main_topic_en: {
            #   text: query,
            #   term: {
            #     field: 'main_topic_en'
            #   }
            }
          },
          # aggregation, will be used for faceted search
          aggs: {
            lang: {
              terms: {
                field: 'split_languages',
                size: 999
              }
            },
            city: {
              terms: {
                field: 'cities.unmod',
                size: 999
              }
            }
          }
        }
        if @filter_cities
          query_hash[:post_filter] = { 'term': { 'cities.unmod': @filter_cities }}
        end

        if @filter_lang
          query_hash[:post_filter] = { 'term': { 'split_languages': @filter_lang }}
        end
        puts query_hash.to_yaml
        __elasticsearch__.search(query_hash)
    end

    def as_indexed_json(options={})
      output = as_json(
        {
          autocomplete: { input:  [fullname, twitter, topic_list] },
          only: [:firstname, :lastname, :twitter, :languages, :city, :country],
            methods: [:fullname, :topic_list, :cities, :split_languages, *globalize_attribute_names],
            include: {
              medialinks: { only: [:title, :description] }
          }
        }
      )
      output.select{ |key, value| value.present? }
    end

    # TO DO
    # Write comments
    # maybe elisions for cities and topic_list and main_topic
    elasticsearch_mappings = {
      index: {
        number_of_shards: 1,
        analysis: {
          filter: {
            synonym_filter: {
              type: 'synonym',
              synonyms: [
                'phd,dr.,dr'
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
          analyzer: {
            twitter_analyzer: {
              type: 'custom',
              tokenizer: 'keyword',
              filter: ['lowercase'],
              char_filter: ['strip_twitter']
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
        }
      }
    }

    ANALYZERS = { de: 'german', en: 'english' }

    settings elasticsearch_mappings do
      mappings dynamic: 'false' do
        indexes :fullname,   type: 'string', analyzer: 'fullname_analyzer',   'norms': { 'enabled': false } do
          indexes :suggest,  type: 'completion'
        end
        indexes :lastname,   type: 'string', analyzer: 'fullname_analyzer',   'norms': { 'enabled': false } do
          indexes :suggest,  type: 'completion'
        end
        indexes :twitter,    type: 'string', analyzer: 'twitter_analyzer',    'norms': { 'enabled': false } do
          indexes :suggest,  type: 'completion'
        end
        indexes :topic_list, type: 'string', analyzer: 'standard', 'norms': { 'enabled': false } do
          indexes :suggest,  type: 'completion'
        end
        I18n.available_locales.each do |locale|
          [:main_topic, :bio].each do |name|
            indexes :"#{name}_#{locale}", type: 'string', analyzer: "#{ANALYZERS[locale]}_without_stemming" do
              if name == :main_topic
                indexes :suggest, type: 'completion'
              end
            end
          end
        end
        indexes :split_languages, type: 'string', analyzer: 'language_analyzer', 'norms': { 'enabled': false }
        indexes :cities, fields: { unmod: { type:  'string', analyzer: 'cities_analyzer', 'norms': { 'enabled': false } }, standard: { type:  'string', analyzer: 'standard', 'norms': { 'enabled': false }} }
        indexes :country,    type: 'string', analyzer: 'standard', 'norms': { 'enabled': false }
        indexes :website,    type: 'string', analyzer: 'standard', 'norms': { 'enabled': false }
        indexes :medialinks, type: 'nested' do
          indexes :title, 'norms': { 'enabled': false }
          indexes :description, 'norms': { 'enabled': false }
        end
      end
    end

    def autocomplete
      {
        input: input.map { |i| i.input.downcase }
      }
    end

    def self.typeahead(q)
      self.__elasticsearch__.client.suggest(index: self.index_name, body: {
        fullname_suggest: {
          text: q,
          completion: { field: 'fullname.suggest'
          }
        },
        lastname_suggest: {
          text: q,
          completion: { field: 'lastname.suggest'
          }
        },
        main_topic_de_suggest: {
          text: q,
          completion: { field: 'main_topic_de.suggest'
          }
        },
        # main_topic_en_suggest: {
        #   text: q,
        #   completion: { field: 'main_topic_en.suggest'
        #   }
        # },
        topic_list_suggest: {
          text: q,
          completion: { field: 'topic_list.suggest'
          }
        }
      })
    end
  end
end
