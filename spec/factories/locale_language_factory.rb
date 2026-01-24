FactoryBot.define do
  factory :locale_language do
    iso_code { 'en' }

    trait :de do
      iso_code { 'de' }
    end

    trait :en do
      iso_code { 'en' }
    end
  end
end
