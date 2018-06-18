# frozen_string_literal: true

namespace :tags do
  desc 'converts upper case tags into lower case ones'
  task convert: :environment do
    uppercase_tags = []
    count = 0
    ActsAsTaggableOn::Tag.all.each do |tag|
      next unless tag.name != tag.name.downcase
      count += 1
      puts tag.name
      tag.name = tag.name.downcase
      tag.save!
    end

    puts "I changed #{count} tags"
  end
end
