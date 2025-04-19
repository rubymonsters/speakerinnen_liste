FactoryBot.define do
  factory :locale_language do
    factory :locale_language_de do
      iso_code { 'de' }
    end

    factory :locale_language_en do
      iso_code { 'en' }
    end
  end
end
