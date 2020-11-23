# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name [Rails.application.engine_name, Rails.env].join('_')

    def self.search(query, filter_countries, filter_cities, filter_lang, with_explain)
      @filter_countries = filter_countries == "" ? nil : filter_countries
      @filter_cities = filter_cities == "" ? nil : filter_cities
      @filter_lang = filter_lang == "" ? nil : filter_lang

      query_hash =
        {
          explain: with_explain,
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
                      'twitter_de',
                      'twitter_en',
                      'iso_languages',
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
                    ]
                  }
                }
              ]
            }
          },
          # aggregations for faceted search
          aggregations: {
            lang: {
              terms: {
                field: 'iso_languages.keyword',
                size: 999
              }
            },
            city: {
              terms: {
                field: 'cities.unmod',
                size: 999
              }
            },
            country: {
              terms: {
                field: 'country.keyword',
                size: 999
              }
            }
          }
        }

      query_hash[:min_score] = 3.00 if Rails.env.production?

      filters = []
      filters << { "term": { "iso_languages": @filter_lang }} if @filter_lang
      filters << { "term": { "cities.unmod": @filter_cities }} if @filter_cities
      filters << { "term": { "country": @filter_countries }} if @filter_countries
      query_hash[:query][:bool][:filter] = filters unless filters.empty?

      __elasticsearch__.search(query_hash)
    end

    def as_indexed_json(_options = {})
      suggest = {
        fullname_suggest: { input: fullname },
        topic_list_suggest: { input: topic_list }
      }

      output = as_json(
        autocomplete: { input: [fullname, twitter_de, twitter_en, topic_list] },
        only: %i[firstname lastname iso_languages country],
        methods: [:fullname, :topic_list, :cities, *globalize_attribute_names],
        include: {
          medialinks: { only: %i[title description] }
        }
      ).merge(suggest)

      output.select { |_key, value| value.present? }
    end

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
              pattern: '[^a-zA-Z0-9]',
              replacement: ''
            }
          },
          analyzer: {
            twitter_analyzer: {
              type: 'custom',
              char_filter: ['strip_twitter'],
              tokenizer: 'keyword',
              filter: ['lowercase']
            },
            cities_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: %w[
                lowercase
                german_normalization
                asciifolding
              ]
            },
            fullname_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: %w[
                lowercase
                german_normalization
                asciifolding
                synonym_filter
              ]
            },
            english_without_stemming: {
              tokenizer:  'standard',
              filter: %w[
                english_possessive_stemmer
                lowercase
                english_stop
                synonym_filter
              ]
            },
            german_without_stemming: {
              tokenizer:  'standard',
              filter: %w[
                lowercase
                german_stop
                german_normalization
                synonym_filter
              ]
            }
          }
        }
      }
    }

    ANALYZERS = { de: 'german', en: 'english' }.freeze

    settings elasticsearch_mappings do
      mappings dynamic: 'false' do
        indexes :fullname,   type: 'text', analyzer: 'fullname_analyzer', 'norms': false do
          indexes :suggest,  type: 'completion'
        end
        indexes :lastname,   type: 'text', analyzer: 'fullname_analyzer', 'norms': false do
          indexes :suggest,  type: 'completion'
        end
        indexes :twitter_de, type: 'text', analyzer: 'twitter_analyzer', 'norms': false do
          indexes :suggest,  type: 'completion'
        end
        indexes :twitter_en, type: 'text', analyzer: 'twitter_analyzer', 'norms': false do
          indexes :suggest,  type: 'completion'
        end
        indexes :topic_list, type: 'text', analyzer: 'standard', 'norms': false do
          indexes :suggest,  type: 'completion'
        end
        I18n.available_locales.each do |locale|
          %i[main_topic bio website].each do |name|
            indexes :"#{name}_#{locale}", type: 'text', analyzer: "#{ANALYZERS[locale]}_without_stemming" do
              indexes :suggest, type: 'completion' if name == :main_topic
            end
          end
        end
        indexes :iso_languages, fields: { keyword: { type: 'keyword', 'norms': false },
                                standard: { type: 'text', analyzer: 'standard', 'norms': false }}
        indexes :cities,        fields: { unmod: { type: 'keyword', 'norms': false },
                                standard: { type: 'text', analyzer: 'cities_analyzer', 'norms':  false }}
        indexes :country,       fields: { keyword: { type: 'keyword', 'norms': false },
                                standard: { type: 'text', analyzer: 'standard', 'norms': false }}
        indexes :medialinks, type: 'nested' do
          indexes :title, 'norms': false
          indexes :description, 'norms': false
        end
      end
    end

    def self.typeahead(q)
      __elasticsearch__.client.search(
        index: index_name,
        body: {
          suggest: {
            fullname_suggest: {
              text: q,
              completion: { field: 'fullname.suggest' }
            },
            lastname_suggest: {
              text: q,
              completion: { field: 'lastname.suggest' }
            },
            main_topic_de_suggest: {
              text: q,
              completion: { field: 'main_topic_de.suggest' }
            },
            main_topic_en_suggest: {
              text: q,
              completion: { field: 'main_topic_en.suggest' }
            },
            topic_list_suggest: {
              text: q,
              completion: { field: 'topic_list.suggest' }
            }
         }
      })
    end
  end
end
