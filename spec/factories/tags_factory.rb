FactoryBot.define do
  factory :tag, class: ActsAsTaggableOn::Tag do
    transient do
      locale_language { nil }
    end

    after(:create) do |tag, evaluator|
      if evaluator.locale_language
        create(
          :tags_locale_language,
          tag: tag,
          locale_language: evaluator.locale_language
        )
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
  end
end
