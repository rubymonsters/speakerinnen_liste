# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    firstname { 'Sonnenschein' }
    lastname { 'Susi' }
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password { '123foobar' }
    password_confirmation { '123foobar' }
    confirmed_at { Time.now }

    factory :admin do
      admin { true }
    end

    factory :published do
      published { true }
    end

    factory :unpublished do
      published { false }
    end

    factory :unconfirmed do
      confirmed_at { nil }
    end

    factory :ada do
      firstname { 'Ada' }
      lastname { 'Lovelace' }
      twitter_en { 'alovelace' }
      city_en { 'London' }
      country { 'GB' }
      iso_languages { ['en'] }
      bio_de { 'Ada: Das ist meine deutsche Bio.' }
      bio_en { 'Ada: This is my english bio.' }
      main_topic_de { 'Mathematik' }
      main_topic_en { 'mathematic' }
      published { true }
    end

    factory :marie do
      firstname { 'Marie' }
      lastname { 'Curie' }
      twitter_en { 'curie' }
      city_en { 'Paris' }
      country { 'FR' }
      iso_languages { ['en', 'pl'] }
      bio_de { 'Marie: Das ist meine deutsche Bio.' }
      bio_en { 'Marie: This is my english bio.' }
      main_topic_de { 'Radioaktivität' }
      main_topic_en { 'radioactivity' }
      published { true }
    end

  end

  factory :featured_profile do
    title { 'New Event' }
  end

  factory :category do
    factory :cat_science do
      name { 'Science' }
    end
    factory :cat_social do
      name { 'Social' }
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
