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
random_number= 1 + rand(9)
tags = ["umweltschutz","Haustiere","Aussenpolitik","Antifaschismus","Mode","Wellness","Familie","Kinder","Mutter sein","Career in life"]

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
                  profession: "Mein Beruf",
                  topic_list: tags[random_number]
  )

  if i % 10 == 0
    Profile.last.medialinks.build(url: "https://www.hacksplaining.com", description: "Security Training for Developers", title: "hacksplaining", language: 'en').save!
    Profile.last.medialinks.build(url: "https://x-hain.de", description: "Das ist eine toller Hackspace in Friedrichshain", title: "X-Hain").save!
    Profile.last.medialinks.build(url: "https://www.klimafakten.de/", description: "klimafakten.de bietet zuverlässige Fakten zum Klimawandel und seinen Folgen. Und wir zeigen, wie man darüber ins Gespräch kommt.", title: "X-klimafakten").save!
  end

  puts "#{i} german profiles created" if (i % 10 == 0)
end

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
                          and revolutionary mass action to achieve international socialism.",
                  profession: "My profession",
                  topic_list: tags[random_number]
                  )
  if i % 10 == 0
    Profile.last.medialinks.build(url: "http://conqueringthecommandline.com/book", description: "Unix and Linux Commands for Developers", title: "conqueringthecommandline", language: "en" ).save!
    Profile.last.medialinks.build(url: "https://linuxjourney.com/", description: "Learn linux for free", title: "linuxjourney", language: "en" ).save!
  end

  puts "#{i} english profiles created" if (i % 10 == 0)
end
# ActsAsTaggableOn::Tag.create(name: "Career in life", ).categories << Category.find_by(name: "Marketing & PR")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.create(name: "Cats").categories << Category.find_by(name: "Body & Soul")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.create(name: "Dog").categories << Category.find_by(name: "Body & Soul")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.create(name: "Politics in Parlament").categories << Category.find_by(name: "Politics & Society")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.create(name: "Javascript").categories << Category.find_by(name: "Science & Technology")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Closure").categories << Category.find_by(name: "Science & Technology")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Latin America").categories << Category.find_by(name: "Politics & Society")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.create(name: "Gender").categories << Category.find_by(name: "Diversity")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Girlsday").categories << Category.find_by(name: "Career & Education")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Klimapolitik").categories << Category.find_by(name: "Environment @ Substainablility")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Climatejustice").categories << Category.find_by(name: "Environment @ Substainablility")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.create(name: "erneuerbare Energien").categories << Category.find_by(name: "Environment @ Substainablility")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Migration in Europe").categories << Category.find_by(name: "Politics & Society")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.create(name: "Everyday Pysics").categories << Category.find_by(name: "Science & Technology")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.create(name: "Social Media").categories << Category.find_by(name: "Internet & Media")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Arbeitsrecht").categories << Category.find_by(name: "Politics & Society")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Gewerkschaft Verdi").categories << Category.find_by(name: "Politics & Society")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Film").categories << Category.find_by(name: "Arts & Culture")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "en")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Feminismus").categories << Category.find_by(name: "Diversity")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Suffragetten").categories << Category.find_by(name: "Diversity")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")
# ActsAsTaggableOn::Tag.create(name: "Eigenständigkeit").categories << Category.find_by(name: "Companies & Start-ups")
# ActsAsTaggableOn::Tag.last.locale_languages << LocaleLanguage.find_by(iso_code: "de")

# puts "21 tags were created and assigned to Categories and languages"




# puts "Tags were added to profiles"

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

Feature.create(position:1, public: true, title: "Climatejustice", description: "how the poor pay for the rich")
Feature.last.profiles=Profile.order("RANDOM()").limit(8).to_a

puts "1 feature with 8 profiles where created"
