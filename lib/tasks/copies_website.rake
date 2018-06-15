# frozen_string_literal: true

desc 'copies website_de into website_en'
task copies_website: :environment do
  Profile.all.each do |profile|
    profile.website_en = profile.website_de
    profile.save!
    puts profile.id.to_s
    puts "website:   #{profile.website}"
    puts "website_de:   #{profile.website_de}"
    puts "website_en:   #{profile.website_en}"
    puts '---------------------------------'
  end
end
