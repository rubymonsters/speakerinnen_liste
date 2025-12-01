FactoryBot.define do
  factory :blocked_email do
    contacted_profile_email { "ada@example.com" }
    subject { "Blocked Subject" }
    name { "Blocked User" }
    email { "sender@example.com" }
    body { "This is a blocked message" }
    created_at { Time.current }
  end
end
