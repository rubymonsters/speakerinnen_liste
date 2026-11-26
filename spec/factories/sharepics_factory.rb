FactoryBot.define do
  factory :sharepic do
    sequence(:title) { |n| "Sharepic #{n}" }
    description { 'Ein Sharepic für Social Media' }
    published { true }
    position { 0 }

    after(:build) do |sharepic|
      sharepic.image.attach(
        io: File.open(Rails.root.join('spec/dummy.png')),
        filename: 'dummy.png',
        content_type: 'image/png'
      )
    end
  end
end
