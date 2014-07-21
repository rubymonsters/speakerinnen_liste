namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    all_topics    = ["Ruby", "Rails", "Gender", "Netpolitics", "Opensource", "Encryption", "Batman"]
    all_languages = ["English", "German", "French", "Polish", "Italian", "Spanish", "Czech"]
    all_talks = ["29C3", "Republica", "DEF CON", "Rails Camp", "EuRuKo2013", "Ruby User Group"]

    6.times do |n|
      email         = "example-#{n+1}@speakerinnen.org"
      password      = "password"
      Profile.create!(firstname: Faker::Name.first_name,
                      lastname: Faker::Name.last_name,
                      email: email,
                      password: password,
                      password_confirmation: password,
                      bio: Faker::Lorem.paragraph,
                      city: Faker::Address.city,
                      topic_list: all_topics.sample(rand(4)+1).join(", "),
                      languages: all_languages.sample(rand(3)+1).join(", "),
                      talks: all_talks.sample(rand(4)). join(", "),
                      picture: File.open(File.join(Rails.root, 'app','assets','images','avatar.jpg')),
                      twitter: Faker::Name.first_name
                     )
      user = Profile.where(email: email).first
      user.admin = (n == 0) ? true : false
      user.confirmed_at = Time.now
      user.save!
    end
  end
end
