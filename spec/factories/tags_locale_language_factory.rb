# frozen_string_literal: true

FactoryBot.define do
  factory :tags_locale_language do
    association :tag, factory: :tag
    association :locale_language
  end
end
