desc "checks for unmatched words"
task unmatches_words: :environment do

  Profile.all.each do |profile|
    profile.split_languages_string.each do |str|
      IsoLanguage.from_string(str)
    end
  end

end

desc "converts languages in iso_languages"
task convert_languages_in_iso: :environment do

  Profile.all.each do |profile|
    languages_code_array = profile.split_languages_string.map do |str|
      IsoLanguage.from_string(str)
    end.compact
    puts "existing languages:   #{profile.languages}"
    puts "to iso_languages:     #{languages_code_array}"
    puts "---------------------------------"
    #profile.languages = languages_code_array
    #profile.save
  end

end


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
