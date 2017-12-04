namespace :tag_locale do
  desc "copies the tag_language to locale_language"
  task copies_locale: :environment do

    ActsAsTaggableOn::Tag.all.each do |tag|
      tag.tag_languages.each do |l|
        puts "Old language is: #{l.language} == #{LocaleLanguage.find_by(iso_code: l.language).iso_code}"
        tag.locale_languages << LocaleLanguage.find_by(iso_code: l.language)
      end
    end

  end

end
