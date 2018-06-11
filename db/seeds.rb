#TODO Create Categories and Tags, then Taggings for the profiles created below
puts "Seeding the database..."
puts "Creating some DE profiles..."

300.times do |i|
  Profile.create!(firstname: "Jane",
                  lastname: "Doe#{i}",
                  email: "jane_doe#{i}@example.com",
                  password: "jane_doe",
                  city_de: "Berlin",
                  country: 'DE',
                  twitter_de: "@janedoe##{i}",
                  website_de: "https://speakerinnen.org",
                  confirmed_at: DateTime.now,
                  published: true,
                  main_topic_de: "Frauen* in Führungspositionen",
                  iso_languages: ['de']
  )

  puts "#{i} profiles created" if (i % 50 == 0)
end

puts "Creating some EN profiles..."

200.times do |i|
  Profile.create!(firstname: "Claire",
                  lastname: "Miller##{i}",
                  email: "claire_miller#{i}@example.com",
                  password: "claire_miller",
                  city_en: "London",
                  country: 'GB',
                  twitter_en: "@clairemiller##{i}",
                  website_en: "https://speakerinnen.org",
                  confirmed_at: DateTime.now,
                  published: true,
                  main_topic_en: "Women* in Tech",
                  iso_languages: ['en']
  )

  puts "#{i} profiles created" if (i % 50 == 0)
end

puts "Creating admin profile..."

Profile.create(firstname: "Karen",
               lastname: "Smith",
               email: "karen@example.com",
               password: "password",
               city_en: "London",
               country: 'GB',
               twitter_en: "@karensmith",
               website_en: "https://speakerinnen.org",
               confirmed_at: DateTime.now,
               published: true,
               admin: true,
               main_topic_en: "Human Rights",
               iso_languages: ['en']
)

puts "1 admin profile created"

Category.create(name: "Marketing & PR", locale: "en")
Category.create(name: "Diversity", locale: "en")
Category.create(name: "Body & Soul", locale: "en")
Category.create(name: "Arts & Culture", locale: "en")
Category.create(name: "Miscellaneous", locale: "en")
Category.create(name: "Internet & Media", locale: "en")
Category.create(name: "Politics & Society", locale: "en")
Category.create(name: "Companies & Start-ups", locale: "en")
Category.create(name: "Career & Education", locale: "en")
Category.create(name: "Science & Technology", locale: "en")

puts "10 categories were created"

ActsAsTaggableOn::Tag.create(name: "Career in life")
ActsAsTaggableOn::Tag.create(name: "I love cats")
ActsAsTaggableOn::Tag.create(name: "I want to be a dog")
ActsAsTaggableOn::Tag.create(name: "Colors are beautiful")
ActsAsTaggableOn::Tag.create(name: "blabla")
ActsAsTaggableOn::Tag.create(name: "Flowers")
ActsAsTaggableOn::Tag.create(name: "Born to be wild")
ActsAsTaggableOn::Tag.create(name: "Dancing shoes")
ActsAsTaggableOn::Tag.create(name: "Carma police")
ActsAsTaggableOn::Tag.create(name: "Call the police")
ActsAsTaggableOn::Tag.create(name: "A day in a life")
ActsAsTaggableOn::Tag.create(name: "Reflektor")
ActsAsTaggableOn::Tag.create(name: "Normal Person")
ActsAsTaggableOn::Tag.create(name: "I am not a toy")
ActsAsTaggableOn::Tag.create(name: "1st Tag")
ActsAsTaggableOn::Tag.create(name: "2nd Tag")
ActsAsTaggableOn::Tag.create(name: "3rd Tag")
ActsAsTaggableOn::Tag.create(name: "4th Tag")
ActsAsTaggableOn::Tag.create(name: "5th Tag")
ActsAsTaggableOn::Tag.create(name: "6th Tag")

puts "20 tags were created"

LocaleLanguage.create(iso_code: "de")
LocaleLanguage.create(iso_code: "en")

puts "2 languages were created"
