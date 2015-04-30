FactoryGirl.define do
  factory :profile do
    firstname "Factory"
    lastname "Girl"
    email "FactoryGirl@test.de"
    password "123foobar"
    password_confirmation "123foobar"
    bio "MyText"
    confirmed_at Time.now

    factory :admin do
      admin true
    end

    factory :published do
      published true
    end

    factory :unpublished do
      published false
    end
  end

  factory :category do
    name "Factory Category"
  end
end
