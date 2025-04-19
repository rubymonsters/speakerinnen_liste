FactoryBot.define do
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
