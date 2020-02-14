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
                  website_2_de: "www.kraftfuttermischwerk.de",
                  website_3_de: "heise.com",
                  confirmed_at: DateTime.now,
                  published: true,
                  main_topic_de: "Frauen* in Führungspositionen",
                  bio_de: "Arendt, geboren 1906 in <b>Linden bei Hannover,</b> aufgewachsen in Königsberg, studierte Philosophie,
                          griechische Philologie und protestantische Theologie bei <i>Heidegger, Bultmann, Hartmann, Husserl und Jaspers </i>
                          und promovierte 1928 bei Jaspers in Philosophie. <br>Aufgrund der politischen Lage in Deutschland begann Arendt,
                          sich praktisch zu engagieren; emigrierte 1933 nach Paris und von dort aus 1941 nach New York. In den Vereinigten
                          Staaten von Amerika als staatenloser Flüchtling geduldet, erhielt sie 1951 die amerikanische Staatsbürgerschaft.<br>
                          Die politischen Ereignisse sowie ihre eigenen Erlebnisse führten dazu, dass sie sich mit politischer Theorie befasste.<br>
                          Arendt starb 1975 in New York.",
                  bio_en:"The life story of the German-Jewish-American philosopher and political theorist <b>Hannah Arendt </b>
                          reads like a parable of the 20th century[i]. Arendt, born in 1906 in Linden near Hanover, grew up in
                           Königsberg, studied philosophy, Greek philology and Protestant theology with <i>Heidegger, Bultmann</i>,
                           Hartmann, Husserl and Jaspers and received her doctorate in philosophy from Jaspers in 1928.
                           Due to the political situation in Germany, Arendt began to engage in practical work;
                           emigrated to Paris in 1933 and from there to New York in 1941. Tolerated in the United States of
                           America as a stateless refugee, she received American citizenship in 1951. The p
                           olitical events as well as her own experiences led her to study political theory.
                           Arendt died in New York in 1975.",
                  iso_languages: ['de','en'],

  )

  if i % 10 == 0
    Profile.last.medialinks.build(url: "https://www.hacksplaining.com", description: "Security Training for Developers", title: "hacksplaining", language: 'en').save!
    Profile.last.medialinks.build(url: "https://x-hain.de", description: "Das ist eine toller Hackspace in Friedrichshain", title: "X-Hain").save!
    Profile.last.medialinks.build(url: "https://www.klimafakten.de/", description: "klimafakten.de bietet zuverlässige Fakten zum Klimawandel und seinen Folgen. Und wir zeigen, wie man darüber ins Gespräch kommt.", title: "X-klimafakten").save!
  end
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
                  website_de: "wwww.heise.de",
                  website_2_en: "www.guardian.com",
                  confirmed_at: DateTime.now,
                  published: true,
                  main_topic_en: "Women* in Tech",
                  iso_languages: ['en'],
                  bio_en: "<b>Rosa Luxemburg</b>, (born March 5, 1871, Zamość, Poland, Russian Empire [now in Poland]—died January 15, 1919,
                          Berlin, Germany), <i>Polish-born German revolutionary</i> and agitator who played a key role in the founding of the Polish
                          ocial Democratic Party and the Spartacus League, which grew into the Communist Party of Germany. <br>
                          As a political theoretician, Luxemburg developed a humanitarian theory of Marxism, stressing democracy
                          and revolutionary mass action to achieve international socialism."
  )
  if i % 10 == 0
    Profile.last.medialinks.build(url: "http://conqueringthecommandline.com/book", description: "Unix and Linux Commands for Developers", title: "conqueringthecommandline", language: "en" ).save!
    Profile.last.medialinks.build(url: "https://linuxjourney.com/", description: "Learn linux for free", title: "linuxjourney", language: "en" ).save!
  end

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
