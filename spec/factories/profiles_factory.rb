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

    factory :inactive do
      inactive { true}
    end

    factory :ada do
      firstname { 'Ada' }
      lastname { 'Lovelace' }
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
end
