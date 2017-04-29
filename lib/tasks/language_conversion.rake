desc "converts languages in iso_languages"
task convert_languages_in_iso: :environment do


  Profile.all.each do |profile|
    #if profile.languages.match(/[D,d]eutsch|D/)
      #ProfileLanguage.create!(profile: profile, iso_639_1: "de")
    #end
    #if profile.languages.match(/[E,e]nglisch|EN/)
      #ProfileLanguage.create!(profile: profile, iso_639_1: "en")
    #end
    #if profile.languages.match(/Türkisch/)
      #ProfileLanguage.create!(profile: profile, iso_639_1: "tr")
    #end

    [:de, :en].each do |l|
      I18n.locale = l
      I18n.t('iso_639_1').each do |iso_code, language|
        if profile.languages?
          if profile.languages.match(/#{language}|#{iso_code}[\,\s\$]/i)
            profile.iso_languages << [iso_code.to_s]
          end
        end
      end
    end
  end
end

# get all the languages we have
#Profile.all.map(&:languages).compact.map{|l| l.split(',')}.flatten.map(&:strip).uniq
#=> ["Deutsch", "Französisch", "Englisch", "English", "deutsch", "englisch", "französisch", "Spanisch", "German", "Spanish", "Polnisch", "Türkisch", "Schwedisch", "Diversity", "HTML", "CSS", "Python", "Deutsch. Englisch", "english", "italienisch", "English (native)", "russisch", "Camfranglais", "spanisch", "Serbokroatisch", "russian", "Franzoesisch", "Italienisch", "Hollaendisch", "Portugiesisch", "Dänisch", "Deutsch und Englisch", "Deutsh", "Italian", "Deustch", "Nederlands", "French", "Latein", "Polish", "Basque", "niederländisch", "Niederländisch", "DE", "EN", "Spanish and French (mother tongues)", "Portuguese (proficiency)", "German (conversational)", "ÖGS", "French (English preferred)", "Russisch", "IT (FR)", "", "Norwegisch", "Dutch", "french", "italien", "spanish", "german (school level)", "Tsüritütsch", "Estnisch", "Deutsche", "DE / EN (FR/ES)", "Bulgarisch", "Chinese", "Kroatisch", "Farsi", "lettisch", "Hindi. Bengali", "bayrisch :)", "Arabisch", "Katalanisch", "Griechisch", "Persisch", "deutsch und englisch", "Hindi", "Français", "Italenisch", "Deutsch (Muttersprache)", "Englisch (sicher)", "Französisch (fortgeschritten)", "Russich (Grundlagen)", "schwedisch & spanisch", "Englisch (Vortragssprachen)", "Englisch (sehr gut)", "Spanisch (Basics und Sprachgefühl)", "Esperanto", "Italiano", "中文", "plattdütsch", "JavaScript", "Ruby", "SQL", "R", "Norsk", "Javascript", "IOS", "Bayrisch", "etwas italienisch", "Sanskrit nur lesen", "Deutsch & Englisch", "Italianisch", "English and Spanish", "deutsch/englisch", "D", "English & German", "Englisch fliessend", "polnisch", "griechisch", "Turkish", "Ru", "Fr", "Bosnisch", "Serbisch", "Französisch (nicht konferenztauglich)", "Rumänisch", "Francais", "englisch & französisch", "Englisch (Durchschnitt)", "Französich (eifrig lernend)", "(Spanisch", "Französisch)", "schwedisch", "Armenisch", "Russian", "Österreichisch", "Español", "Portugues", "some French", "a little German", "Schwedisch (Italienisch)", "Schweizerdeutsch", "Russisch (Grundkenntnisse)", "Sanskrit", "GK Spanisch", "Gujarati", "Chinesisch", "weitere", "German English", "E", "F", "Swedish", "deutsch & englisch", "(Italienisch", "Thai)", "Englisch und Schwedisch", "Englisch und Französisch", "portugiesisch", "Englisch (eingeschränkt)", "Spanisch und Igbo(Nigeria)", "Deutsch Englisch Spanisch", "Norwegian", "Kurdisch", "Klartext", "Belarussisch", "(Französisch", "Italienisch)", "Französisch (Spanisch", "Schwedisch)", "Deutsch; Englisch", "Englisch (& Französisch)", "javascript", "php", "python", "r", "c", "Ungarisch", "Deutsche Gebärdensprache", "Österreichisches und Deutsches Deutsch", "Amerikanisches Englisch (alles akzentfrei)", "Deutsch / Englisch", ".Englisch", "HTML/CSS", "toy languages", "Englisch (fließend)", "Französisch (gut)", "Spanisch (gut)", "Tschechisch", "Grundkenntnisse Italienisch", "ein bisschen Japanisch", "Französich", "Deutsch/Englisch", "NL", "portuguese br", "Deutsch - Englisch", "Spanisch (nach einem Glas Rioja wieder Grundkenntnisse)", "Hebräisch", "Romanisch", "CH-Deutsch", "de", "Englisch und Französisch fließend", "Spanisch und Italienisch Grundkenntnisse", "Japanese", "Englisch (B2)", "Portugiesisch (C1)", "German and English", "Greek", "Diverse Deutsche Dialekte", "Gebärdensprache (DGS II)", "(German)", "Deutsch Englisch", "spanisch (Grundkenntnisse)", "(Polnisch)", "ungarisch", "Französisch (Grundkenntnisse)", "Italienisch (Grundkenntnisse)", "Isländisch (Grundkenntnisse", "Englisch; Französisch; Italienisch; Luxemburgisch", "german", "D / E", "französisch (Grundlagen)", "Urdu", "Englisch / Deutsch", "Englisch (flüssig)", "français", "ein wenig Russisch", "Englisch (Niederländisch", "Spanisch)", "Englisch und Kroatisch", "Schwedisch (Fortgeschritten)", "Finnisch", "Basics in Arabic", "Kurdish", "Spanisch und Englisch (zudem Französisch und Russisch)"]
#=> 223
#
desc "prints languages in iso_languages"
task prints_languages_in_iso: :environment do
  Profile.all.map do |profile|
    puts "------------------"
    puts "profile.id: #{profile.id}"

    [:de, :en].each do |l|
      I18n.locale = l

      I18n.t('iso_639_1').map do |iso_code, language|
        if profile.languages?
          if profile.languages.match(/#{language}|#{iso_code}[\,\s\$]/i)
            puts "existing languages:#{profile.languages} to iso_languages: #{iso_code.to_s}"
          end
        end
      end
    end
  end
end


#HUPS:
#profile.id: 751
#existing languages:Deutsch, English to iso_languages: de

#oder:
#profile.id: 751
existing languages:Deutsch, English to iso_languages: de
