#TODO Create Categories and Tags, then Taggings for the profiles created below
puts "Seeding the database..."
puts "Creating some DE profiles..."

# 300.times do |i|
#   Profile.create!(firstname: "Jane",
#                   lastname: "Doe#{i}",
#                   email: "jane_doe#{i}@example.com",
#                   password: "jane_doe",
#                   city_de: "Berlin",
#                   country: 'DE',
#                   twitter_de: "@janedoe##{i}",
#                   website_de: "https://speakerinnen.org",
#                   confirmed_at: DateTime.now,
#                   published: true,
#                   main_topic_de: "Frauen* in Führungspositionen",
#                   iso_languages: ['de']
#   )
#
#   puts "#{i} profiles created" if (i % 50 == 0)
# end
#
# puts "Creating some EN profiles..."
#
# 200.times do |i|
#   Profile.create!(firstname: "Claire",
#                   lastname: "Miller##{i}",
#                   email: "claire_miller#{i}@example.com",
#                   password: "claire_miller",
#                   city_en: "London",
#                   country: 'GB',
#                   twitter_en: "@clairemiller##{i}",
#                   website_en: "https://speakerinnen.org",
#                   confirmed_at: DateTime.now,
#                   published: true,
#                   main_topic_en: "Women* in Tech",
#                   iso_languages: ['en']
#   )
#
#   puts "#{i} profiles created" if (i % 50 == 0)
# end
#
# puts "Creating admin profile..."
#
# Profile.create(firstname: "Karen",
#                lastname: "Smith",
#                email: "karen@example.com",
#                password: "password",
#                city_en: "London",
#                country: 'GB',
#                twitter_en: "@karensmith",
#                website_en: "https://speakerinnen.org",
#                confirmed_at: DateTime.now,
#                published: true,
#                admin: true,
#                main_topic_en: "Human Rights",
#                iso_languages: ['en']
# )
#
# puts "1 admin profile created"
#
# Category.create(name: "Marketing & PR", locale: "en")
# Category.create(name: "Diversity", locale: "en")
# Category.create(name: "Body & Soul", locale: "en")
# Category.create(name: "Arts & Culture", locale: "en")
# Category.create(name: "Miscellaneous", locale: "en")
# Category.create(name: "Internet & Media", locale: "en")
# Category.create(name: "Politics & Society", locale: "en")
# Category.create(name: "Companies & Start-ups", locale: "en")
# Category.create(name: "Career & Education", locale: "en")
# Category.create(name: "Science & Technology", locale: "en")
#
# puts "10 categories were created"

# ActsAsTaggableOn::Tag.create(name: "Career in life")
# ActsAsTaggableOn::Tag.create(name: "I love cats")
# ActsAsTaggableOn::Tag.create(name: "I want to be a dog")
# ActsAsTaggableOn::Tag.create(name: "Colors are beautiful")
# ActsAsTaggableOn::Tag.create(name: "Flowers")
# ActsAsTaggableOn::Tag.create(name: "Born to be wild")
# ActsAsTaggableOn::Tag.create(name: "Dancing shoes")
# ActsAsTaggableOn::Tag.create(name: "Carma police")
# ActsAsTaggableOn::Tag.create(name: "Call the police")
# ActsAsTaggableOn::Tag.create(name: "A day in a life")
# ActsAsTaggableOn::Tag.create(name: "Reflektor")
# ActsAsTaggableOn::Tag.create(name: "Normal Person")
# ActsAsTaggableOn::Tag.create(name: "I am not a toy")
# ActsAsTaggableOn::Tag.create(name: "1st Tag")
# ActsAsTaggableOn::Tag.create(name: "2nd Tag")
# ActsAsTaggableOn::Tag.create(name: "3rd Tag")
# ActsAsTaggableOn::Tag.create(name: "4th Tag")
# ActsAsTaggableOn::Tag.create(name: "5th Tag")
# ActsAsTaggableOn::Tag.create(name: "6th Tag")
# ActsAsTaggableOn::Tag.create(name: "7th Tag")
# ActsAsTaggableOn::Tag.create(name: "8th Tag")
# ActsAsTaggableOn::Tag.create(name: "9th Tag")
# ActsAsTaggableOn::Tag.create(name: "10th Tag")

puts "23 tags were created"

profile1 = Profile.find(1)
profile2 = Profile.find(2)
profile3 = Profile.find(3)
profile4 = Profile.find(4)
profile5 = Profile.find(5)
profile6 = Profile.find(6)
profile7 = Profile.find(7)
profile8 = Profile.find(8)
profile9 = Profile.find(9)
profile10 = Profile.find(10)
profile11 = Profile.find(11)
profile12 = Profile.find(12)

profile1.topic_list.add(["Career in life", "I love cats"])
profile2.topic_list.add(["I want to be a dog", "Colors are beautiful"])
profile3.topic_list.add(["Flowers", "Born to be wild"])
profile4.topic_list.add(["Dancing shoes", "Carma police"])
profile5.topic_list.add(["Call the police", "A day in a life"])
profile6.topic_list.add(["Reflektor", "Normal Person"])
profile7.topic_list.add(["I am not a toy"])
profile8.topic_list.add(["1st Tag", "2nd Tag"])
profile9.topic_list.add(["3rd Tag", "4th Tag"])
profile10.topic_list.add(["5th Tag", "6th Tag"])
profile11.topic_list.add(["7th Tag", "8th Tag"])
profile12.topic_list.add(["9th Tag", "10th Tag"])

profile1.save
profile2.save
profile3.save
profile4.save
profile5.save
profile6.save
profile7.save
profile8.save
profile9.save
profile10.save
profile11.save
profile12.save

puts "Tags were added to profiles"

# LocaleLanguage.create(iso_code: "de")
# LocaleLanguage.create(iso_code: "en")
#
# puts "2 languages were created"
