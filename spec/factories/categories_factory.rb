FactoryBot.define do
  factory :category do
    factory :cat_science do
      name_en { 'Science' }
      name_de { 'Wissenschaft' }
    end
    factory :cat_social do
      name_en { 'Social' }
      name_de { 'Soziales' }
    end
  end
end
