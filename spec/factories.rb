# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    firstname 'Factory'
    lastname 'Girl'
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password '123foobar'
    password_confirmation '123foobar'
    confirmed_at Time.now

    factory :admin do
      admin true
    end

    factory :published do
      published true
    end

    factory :unpublished do
      published false
    end

    factory :unconfirmed do
      confirmed_at nil
    end
  end

  factory :featured_profile do
    title 'gaming'
    profile_ids [1]
    self.public true
  end

  factory :category do
    factory :cat_science do
      name 'Science'
    end
    factory :cat_social do
      name 'Social'
    end
  end

  factory :locale_language do
    factory :locale_language_de do
      iso_code 'de'
    end

    factory :locale_language_en do
      iso_code 'en'
    end
  end

  factory :medialink do
    profile_id 1
    url 'http://www.somesite.com/profile'
    title 'thisTitle'
    description 'lorep ipsum...'
  end

  factory :tag, class: ActsAsTaggableOn::Tag do
    factory :tag_chemie do
      name 'chemie'
    end

    factory :tag_physics do
      name 'physics'
    end

    factory :tag_social_media do
      name 'social media'
    end
  end
end
