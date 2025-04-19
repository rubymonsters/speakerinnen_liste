FactoryBot.define do
  factory :medialink do
    profile_id { 1 }
    url { 'http://www.somesite.com/profile' }
    title { 'thisTitle' }
    description { 'lorep ipsum...' }
  end
end
