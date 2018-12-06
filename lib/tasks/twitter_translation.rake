# frozen_string_literal: true

desc 'copies twitter_de into twitter_en'
task copies_twitter: :environment do
  Profile.all.each do |profile|
    profile.twitter_en = profile.twitter_de
    profile.save!
    puts profile.id.to_s
    puts "twitter:   #{profile.twitter}"
    puts "twitter_de:   #{profile.twitter_de}"
    puts "twitter_en:   #{profile.twitter_en}"
    puts '---------------------------------'
  end
end
