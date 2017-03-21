FactoryGirl.define do
  factory :profile do
    firstname "Factory"
    lastname "Girl"
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "123foobar"
    password_confirmation "123foobar"
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

    factory :unconfirmed do
      confirmed_at nil
    end
  end

  factory :category do
    name 'Factory Category DE'
  end

  factory :medialink do
    profile_id 1
    url 'http://www.somesite.com/profile'
    title 'thisTitle'
    description 'lorep ipsum...'
  end
end
