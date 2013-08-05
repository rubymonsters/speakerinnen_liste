namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Profile.create!(firstname: "Example Firstname",
                  lastname: "Example Lastname",
                 email: "example@speakerinnen.org",
                 password: "123foobar",
                 password_confirmation: "123foobar",
                 bio: "Random text",
                 city: "Berlin",
                 topic_list: "Comics",
                 languages: "English, German",
                 talks: "Republica",
                 # picture: File.open(Dir.glob(File.join(Rails.root, 'app/assets/images/sampleimages', '*')).sample),
                 twitter: "example",
                 )
    10.times do |n|
      firstname  = Faker::Name.first_name
      lastname  = Faker::Name.last_name
      email = "example-#{n+1}@speakerinnen.org"
      password  = "password"
      bio = Faker::Lorem.paragraph
      city = Faker::Address.city
      all_topics = ["Ruby", "Rails", "Gender", "Netpolitics", "Opensource", "Encryption", "Batman"]
      topic_list = all_topics.sample(rand(4)+1).join(" ")
      all_languages = ["English", "German", "French", "Polish", "Italian", "Spanish", "Czech"]
      languages = all_languages.sample(rand(3)+1).join(", ") 
      all_talks = ["29C3", "Republica", "DEF CON", "Rails Camp", "EuRuKo2013", "Ruby User Group"]
      talks = all_talks.sample(rand(4)). join(", ")
      sample_image = File.open(Dir.glob(File.join(Rails.root, 'app/assets/images/sampleimages', '*')).sample)
      twitter = Faker::Name.first_name
      Profile.create!(  firstname: firstname,
                        lastname: lastname,
                        email: email,
                        password: password,
                        password_confirmation: password,
                        bio: bio,
                        city: city,
                        topic_list: topic_list,
                        languages: languages,
                        talks: talks,
                        picture: sample_image,
                        twitter: twitter
                        )
    end
  end
end