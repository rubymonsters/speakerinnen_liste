#TODO Create Categories and Tags, then Taggings for the profiles created below
puts "Seeding the database..."

puts "Creating some profiles..."
5000.times do |i|
  profile = Profile.create!(firstname: "Jane",
                            lastname: "Doe ##{i}",
                            email: "jane_doe#{i}@example.com",
                            languages: "Deutsch, English, Français",
                            city: "Berlin",
                            country: 'DE'
                            twitter: "@janedoe##{i}",
                            confirmed_at: DateTime.now,
                            published: true,
                            website: "https://speakerinnen.org",
                            password: "jane_doe")

  puts "#{i} profiles created" if (i % 50 == 0)
end
