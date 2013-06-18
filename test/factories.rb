FactoryGirl.define do
  factory :user do
    firstname "Factory"
    lastname "Girl"
    email "FactoryGirl@test.de"
    password "foobar"
    password_confirmation "foobar"
    bio "MyText"
  end
end