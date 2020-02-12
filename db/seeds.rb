puts "Seeding the database..."

LocaleLanguage.create(iso_code: "de")
LocaleLanguage.create(iso_code: "en")

puts "2 languages were created"

Category.create(name_en: "Marketing & PR", name_de:  "Marketing & PR")
Category.create(name_en: "Diversity", name_de: "Diversität")
Category.create(name_en: "Body & Soul", name_de: "Körper & Geist")
Category.create(name_en: "Arts & Culture", name_de: "Kunst & Kultur")
Category.create(name_en: "Environment @ Substainablility", name_de: "Umwelt & Nachhaltigkeit")
Category.create(name_en: "Internet & Media", name_de: "Internet & Medien")
Category.create(name_en: "Politics & Society", name_de: "Politik & Gesellschaft ")
Category.create(name_en: "Companies & Start-ups", name_de: "Unternehmen & Gründungen")
Category.create(name_en: "Career & Education", name_de: "Beruf & Bildung")
Category.create(name_en: "Science & Technology", name_de: "Wissenschaft & Technik")

puts "10 categories were created"

ActsAsTaggableOn::Tag.create(name: "Career in life", ).categories << Category.find_by(name: "Marketing & PR")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.create(name: "Cats").categories << Category.find_by(name: "Body & Soul")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.create(name: "Dog").categories << Category.find_by(name: "Body & Soul")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.create(name: "Politics in Parlament").categories << Category.find_by(name: "Politics & Society")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.create(name: "Javascript").categories << Category.find_by(name: "Science & Technology")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Closure").categories << Category.find_by(name: "Science & Technology")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Latin America").categories << Category.find_by(name: "Politics & Society")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.create(name: "Gender").categories << Category.find_by(name: "Diversity")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Girlsday").categories << Category.find_by(name: "Career & Education")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Klimapolitik").categories << Category.find_by(name: "Environment @ Substainablility")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Climatejustice").categories << Category.find_by(name: "Environment @ Substainablility")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.create(name: "erneuerbare Energien").categories << Category.find_by(name: "Environment @ Substainablility")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Migration in Europe").categories << Category.find_by(name: "Politics & Society")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.create(name: "Everyday Pysics").categories << Category.find_by(name: "Science & Technology")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.create(name: "Social Media").categories << Category.find_by(name: "Internet & Media")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Arbeitsrecht").categories << Category.find_by(name: "Politics & Society")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Gewerkschaft Verdi").categories << Category.find_by(name: "Politics & Society")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Film").categories << Category.find_by(name: "Arts & Culture")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Feminismus").categories << Category.find_by(name: "Diversity")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Suffragetten").categories << Category.find_by(name: "Diversity")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
ActsAsTaggableOn::Tag.create(name: "Eigenständigkeit").categories << Category.find_by(name: "Companies & Start-ups")
ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")

puts "21 tags were created and assigned to Categories and languages"



puts "Creating some DE profiles..."
random_number= 1 + rand(20)

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
                  profession: "Mein Beruf",
                  iso_languages: ['de'],
                  topic_list: ActsAsTaggableOn::Tag.order("RANDOM()").limit(1 + rand(5)).to_a
  )

  puts "#{i} german profiles created" if (i % 10 == 0)
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
                  profession: "My profession",
                  iso_languages: ['en'],
                  topic_list: ActsAsTaggableOn::Tag.order("RANDOM()").limit(1 + rand(5)).to_a
                  )


  puts "#{i} english profiles created" if (i % 10 == 0)
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

Feature.create(position:1, public: true, title: "Climatejustice", description: "how the poor pay for the rich")
Feature.last.profiles=Profile.order("RANDOM()").limit(8).to_a

puts "1 feature with 8 profiles where created"


