# frozen_string_literal: true

namespace :city_translation do
  desc 'copies city_en into city_de'
  task copies_city: :environment do
    Profile.all.each do |profile|
      profile.city_de = profile.city_en
      profile.save!
      puts profile.id.to_s
      puts "city:   #{profile.city}"
      puts "city_de:   #{profile.city_de}"
      puts "city_en:   #{profile.city_en}"
      puts '---------------------------------'
    end
  end
end
