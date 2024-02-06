# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    firstname { 'Susi' }
    lastname { 'Sonnenschein' }
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password { '123foobar' }
    password_confirmation { '123foobar' }
    confirmed_at { Time.now }

    factory :admin do
      admin { true }
    end

    factory :published_profile do
      published { true }
    end

    factory :unpublished_profile do
      published { false }
    end

    factory :unconfirmed_profile do
      confirmed_at { nil }
    end

    factory :ada do
      firstname { 'Ada' }
      lastname { 'Lovelace' }
      twitter_de { 'alovelace_de' }
      twitter_en { 'alovelace_en' }
      city_en { 'London' }
      state { 'carinthia' }
      country { 'AT' }
      iso_languages { ['en', 'de'] }
      bio_de { 'Sie hat den ersten Algorithmus veröffentlicht.' }
      bio_en { 'She published the first algorithm for a machine.' }
      main_topic_de { 'Mathematik Genie' }
      main_topic_en { 'math wiz' }
      website_de { 'www.ada.de' }
      website_2_de { 'wwww.ada2.de' }
      website_3_de { 'wwww.ada3.de' }
      published { true }
      profession { 'computer scientist' }
    end

    factory :marie do
      firstname { 'Marie' }
      lastname { 'Curie' }
      twitter_en { 'curie' }
      city_de { 'Paris' }
      city_en { 'Paris' }
      country { 'FR' }
      iso_languages { ['en', 'pl'] }
      bio_de { 'Marie Curie war die erste Frau, die einen Nobelpreis bekommen hat.' }
      bio_en { 'Marie Curie was the first woman to be awarded a Nobel Prize.' }
      main_topic_de { 'Radioaktivität' }
      main_topic_en { 'radioactivity' }
      published { true }
      profession { 'chemist' }
    end

    factory :laura do
      firstname { 'Laura' }
      country { 'AT' }
      state { :vorarlberg }
      twitter_de { 'laurastwitter' }
      iso_languages { ['de', 'en'] }
      main_topic_de { 'Umwelt' }
      published { true }
    end

    factory :paula do
      firstname { 'Paula' }
      country { 'AT' }
      state { :vorarlberg }
      iso_languages { ['de', 'pl'] }
      main_topic_de { 'Spiele' }
      published { true }
    end

    factory :phantom_of_the_opera do
      firstname { 'Phantom' }
      lastname { 'of the Opera' }
      twitter_en { 'phantom_of_the_opera' }
      city_en { }
      country { }
      iso_languages { }
      bio_de { 'unknown' }
      bio_en { 'unknown' }
      main_topic_de { }
      main_topic_en { }
      published { true }
      profession { }
    end

  end

  factory :feature do
    title  { New Event }
  end

  factory :category do
    factory :cat_science do
      name_en { 'Science' }
      name_de { 'Wissenschaft' }
    end
    factory :cat_social do
      name_en { 'Social' }
      name_de { 'Soziales' }
    end
  end

  factory :locale_language do
    factory :locale_language_de do
      iso_code { 'de' }
    end

    factory :locale_language_en do
      iso_code { 'en' }
    end
  end

  factory :medialink do
    profile_id { 1 }
    url { 'http://www.somesite.com/profile' }
    title { 'thisTitle' }
    description { 'lorep ipsum...' }
  end

  factory :tag, class: ActsAsTaggableOn::Tag do
    factory :tag_chemie do
      name { 'chemie' }
    end

    factory :tag_physics do
      name { 'physics' }
    end

    factory :tag_social_media do
      name { 'social media' }
    end

    factory :tag_algorithm do
      name { 'algorithm' }
    end
  end
end
