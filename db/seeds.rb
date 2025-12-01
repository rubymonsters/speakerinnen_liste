class Seeds
  def initialize
    @languages = ["en", "de"]
      @cities = %w[Berlin London Stuttgart Leipzig Hamburg Dresden]
    @categories = [
      { slug: "marketing", name_en: "Marketing & PR", name_de: "Marketing & PR"},
      { slug: "diversity", name_en: "Diversity", name_de: "Diversität" },
      { slug: "soul", name_en: "Body & Soul", name_de: "Körper & Geist" },
      { slug: "arts", name_en: "Arts & Culture", name_de: "Kunst & Kultur" },
      { slug: "environment", name_en: "Environment & Sustainability", name_de: "Umwelt & Nachhaltigkeit" },
      { slug: "internet", name_en: "Internet & Media", name_de: "Internet & Medien" },
      { slug: "politics", name_en: "Politics & Society", name_de: "Politics & Society" },
      { slug: "companies", name_en: "Companies & Start-ups", name_de: "Unternehmen & Gründungen" },
      { slug: "career", name_en: "Career & Education", name_de:"Career & Education" },
      { slug: "science", name_en: "Science & technology", name_de: "Wissenschaft & Technik" }
    ]
    @tags = {
      "en" => [
        "Career in life",
        "Presentations",
        "Cats",
        "Dogs",
        "Spirtuality",
        "Religion",
        "Latin Americe",
        "Modern art",
        "Climate justice",
        "Climate Activism",
        "Social Media",
        "User exxperience",
        "Feminism",
        "Migration in Europe",
        "Gender",
        "Investment",
        "Career counseling",
        "Career change",
        "Everyday Pysics",
        "Tech"
      ],
      "de" => [
        "Eigenwerbung",
        "Marketing",
        "Diversität",
        "Feminismus",
        "Wellness",
        "Haustiere",
        "Kunst",
        "Kultur",
        "Klimapolitik",
        "Umweltschutz",
        "Twitter",
        "TikTok",
        "Arbeitsrecht",
        "Aussenpolitik",
        "Eigenständigkeit",
        "Unternehmen",
        "Antifaschismus",
        "Kinder",
        "Wissenschaft",
        "Computers"
      ]
    }

    @tags_en_de = [
      "Crowd speaking",
      "Queer",
      "Sauna",
      "Film",
      "Environment",
      "Facebook",
      "Politics",
      "Startup",
      "Career",
      "Microservices"
    ]
  end

  def run
    puts "Seeding the database..."

    @languages.each { |value| LocaleLanguage.find_or_create_by(iso_code: value) }
    puts "2 languages were created"

    @categories.each do |names|
      Category.create(slug: names[:slug], name_en: names[:name_en], name_de: names[:name_de])
    end

    create_tags_with_one_language("en")
    puts "English tags were created and assigned to Categories and Languages"

    create_tags_with_one_language("de")
    puts "German tags were created and assigned to Categories and Languages"

    #TODO: create tags with both languages

    puts "Creating 10 DE profiles..."
    10.times do |i|
      Profile.create!(firstname: "Jane",
                      lastname: "Doe#{i}",
                      email: "jane_doe#{i}@example.com",
                      password: "jane_doe",
                      city_de: @cities.sample,
                      country: 'DE',
                      website_de: "https://speakerinnen.org",
                      website_2_de: "https://www.kraftfuttermischwerk.de",
                      website_3_de: "https://heise.com",
                      instagram: "https://www.instagram.com/jane_doe#{i}",
                      mastodon: "https://www.mastodon.com/jane_doe#{i}",
                      linkedin: "https://www.linkedin.com/in/jane_doe#{i}",
                      bluesky: "https://www.bluesky.com/jane_doe#{i}",
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
                      topic_list: build_tags_for_profile(i, "de")
      )

      if i % 2 == 0
        Profile.last.medialinks.build(url: "https://www.hacksplaining.com", description: "Security Training for Developers", title: "hacksplaining", language: 'en').save!
        Profile.last.medialinks.build(url: "https://x-hain.de", description: "Das ist eine toller Hackspace in Friedrichshain", title: "X-Hain").save!
        Profile.last.medialinks.build(url: "https://www.klimafakten.de/", description: "klimafakten.de bietet zuverlässige Fakten zum Klimawandel und seinen Folgen. Und wir zeigen, wie man darüber ins Gespräch kommt.", title: "X-klimafakten").save!
      end

    end

    puts "Creating 10 EN profiles..."
    10.times do |i|
      Profile.create!(firstname: "Claire",
                      lastname: "Miller##{i}",
                      email: "claire_miller#{i}@example.com",
                      password: "claire_miller",
                      city_en: @cities.sample,
                      country: 'GB',
                      website_en: "https://speakerinnen.org",
                      website_de: "https://www.heise.de",
                      website_2_en: "https://www.guardian.com",
                      instagram: "https://www.instagram.com/claire_miller#{i}",
                      mastodon: "https://www.mastodon.com/claire_miller#{i}",
                      linkedin: "https://www.linkedin.com/claire_miller#{i}",
                      bluesky: "https://www.bluesky.com/claire_miller#{i}",
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
                      topic_list: build_tags_for_profile(i, "en")
                      )
      if i % 2 == 0
        Profile.last.medialinks.build(url: "http://conqueringthecommandline.com/book", description: "Unix and Linux Commands for Developers", title: "conqueringthecommandline", language: "en" ).save!
        Profile.last.medialinks.build(url: "https://linuxjourney.com/", description: "Learn linux for free", title: "linuxjourney", language: "en" ).save!
      end
    end

    Profile.create(firstname: "Karen",
                  lastname: "Smith",
                  email: "karen@example.com",
                  password: "password",
                  city_en: "London",
                  country: 'GB',
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
  end

  def create_tags_with_one_language(lang)
        for i in 0...@categories.length do
          category =  Category.all.sample
          language = LocaleLanguage.find_by(iso_code: lang)
          tag_1    = ActsAsTaggableOn::Tag.create(name: @tags[lang][i*2-1])
          tag_1.categories << category
          tag_1.locale_languages << language
          tags_2 = ActsAsTaggableOn::Tag.create(name: @tags[lang][i*2])
          tags_2.categories << category
          tags_2.locale_languages << language
          #TODO: assign some tags to more then 1 category
        end
  end

  def build_tags_for_profile(i, lang)
    tags_bank = @tags[lang]
    selected_tags = []
    j = i % 10
    k = (i % 10) + 10
    if i % 2 == 0
      8.times do
        selected_tags << tags_bank[j]
        j = j + 1
      end
    else
      7.times do
        selected_tags << tags_bank[k]
        k = k + 1
        break if k >= tags_bank.length
      end
    end
    selected_tags
  end

  ['fuck', 'shit', 'ass', 'nazi'].each do |word|
    OffensiveTerm.find_or_create_by!(word: word.downcase)
  end

  puts 'Offensive Terms were created'
end

Seeds.new.run
