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