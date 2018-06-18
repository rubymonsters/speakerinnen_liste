# frozen_string_literal: true

desc 'Fetch Blog Posts from blog and put them in db'
task import_blog: :environment do
  puts 'Updating from Blog...'
  BlogPost.update
  puts 'done.'
end
