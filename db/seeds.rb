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


puts "Creating some DE profiles..."
main_topics = %w[Ruby Rails Gender Netpolitics Opensource Encryption Batman]
tags = ['Umweltschutz', 'Haustiere', 'Aussenpolitik', 'Antifaschismus', 'Mode', 'Wellness', 'Ruby', 'Social Media', 'Career in life']
states = %w[Vorarlberg Berlin Bayern]

300.times do |i|
  Profile.create!(firstname: Faker::Name.first_name,
                  lastname: Faker::Name.last_name,
                  email: "jane_doe#{i}@example.com",
                  password: "password",
                  city_de: Faker::Address.city,
                  country: Faker::Address.country_code,
                  twitter_de: Faker::Twitter.screen_name,
                  website_de: "https://speakerinnen.org",
                  website_2_de: "www.kraftfuttermischwerk.de",
                  website_3_de: "heise.com",
                  confirmed_at: DateTime.now,
                  published: true,
                  main_topic_de: main_topics[rand(1..7)],
                  bio_de: Faker::Lorem.paragraph,
                  bio_en: Faker::Lorem.paragraph,
                  iso_languages: ['de','en'],
                  topic_list: tags.sample(rand(1..3)).join(', ')
  )

  if i % 10 == 0
    Profile.last.medialinks.build(url: "https://www.hacksplaining.com", description: "Security Training for Developers", title: "hacksplaining", language: 'en').save!
    Profile.last.medialinks.build(url: "https://x-hain.de", description: "Das ist eine toller Hackspace in Friedrichshain", title: "X-Hain").save!
    Profile.last.medialinks.build(url: "https://www.klimafakten.de/", description: "klimafakten.de bietet zuverlässige Fakten zum Klimawandel und seinen Folgen. Und wir zeigen, wie man darüber ins Gespräch kommt.", title: "X-klimafakten").save!
  end

  puts "#{i} german profiles created" if (i % 10 == 0)
end

200.times do |i|
  Profile.create!(firstname: Faker::Name.first_name,
                  lastname: Faker::Name.last_name,
                  email: "claire_miller#{i}@example.com",
                  password: "password",
                  city_en: Faker::Address.city,
                  country: Faker::Address.country_code,
                  twitter_en: Faker::Twitter.screen_name,
                  website_en: "https://speakerinnen.org",
                  website_de: "wwww.heise.de",
                  website_2_en: "www.guardian.com",
                  confirmed_at: DateTime.now,
                  published: true,
                  main_topic_en: main_topics[rand(1..7)],
                  iso_languages: ['en'],
                  bio_en: Faker::Lorem.paragraph,
                  topic_list: tags.sample(rand(1..3)).join(', ')
                  )
  if i % 10 == 0
    Profile.last.medialinks.build(url: "http://conqueringthecommandline.com/book", description: "Unix and Linux Commands for Developers", title: "conqueringthecommandline", language: "en" ).save!
    Profile.last.medialinks.build(url: "https://linuxjourney.com/", description: "Learn linux for free", title: "linuxjourney", language: "en" ).save!
  end

  puts "#{i} english profiles created" if (i % 10 == 0)
end

# Admin user
Profile.create(firstname: "Karen",
               lastname: "Smith",
               email: "karen@example.com",
               password: "password",
               city_en: "London",
               country: 'GB',
               twitter_en: "@karensmith",
               website_en: "https://speakerinnen.org",
               website_2_en: "www.guardian.com",
               confirmed_at: DateTime.now,
               published: true,
               admin: true,
               main_topic_en: "Human Rights",
               iso_languages: ['en','de'],
               bio_de: "<b>Clara Helene Immerwahr</b> verh. Clara Haber (* 21. Juni 1870 in Polkendorf bei Breslau;[1]<br>
                       † 2. Mai 1915 in Dahlem bei Berlin) war eine deutsche Chemikerin.<br>
                        Als sie 1900 an der Universität Breslau promovierte, war <i>sie erst die zweite Frau, </i<
                        die in Deutschland einen Doktorgrad in Chemie erwarb.
                        Wissenschaftlich arbeitete sie im damals neuen Feld der physikalischen Chemie. <br>
                        Nach einem Jahr Berufstätigkeit am chemischen Institut ihres Doktorvaters Richard Abegg in Breslau
                        heiratete sie 1901 den späteren Nobelpreisträger Fritz Haber und musste ihren Beruf aufgeben.
                        Die Ehe verlief unglücklich, insbesondere nach der Geburt ihres Sohnes 1902.
                        Im Jahr 1915 nahm sich Clara Haber das Leben."
)

puts "1 admin profile created"

dach_profiles = Profile.where(country: %w[DE AT CH])
dach_profiles.update(state: states[rand(0..2)])

Feature.create(position:1, public: true, title: "Climatejustice", description: "how the poor pay for the rich")
Feature.last.profiles=Profile.order("RANDOM()").limit(8).to_a

puts "1 feature with 8 profiles where created"
