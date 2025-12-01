FactoryBot.define do
  factory :category do
    factory :cat_science do
      slug { 'science' }
      name_en { 'Science' }
      name_de { 'Wissenschaft' }
    end
    factory :cat_social do
      slug { 'social' }
      name_en { 'Social' }
      name_de { 'Soziales' }
    end
  end
end
