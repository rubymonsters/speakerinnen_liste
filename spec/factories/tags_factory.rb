FactoryBot.define do
  factory :tag, class: ActsAsTaggableOn::Tag do
    transient do
      locales { [] } # default: empty array → no languages
    end

    after(:create) do |tag, evaluator|
      evaluator.locales.each do |locale|
        create(:tags_locale_language, tag: tag, locale_language: locale)
      end
    end

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

    factory :tag_winter do
      name { 'winter' }
    end

    factory :tag_spring do
      name { 'spring' }
    end

    factory :tag_summer do
      name { 'summer' }
    end
  end
end
