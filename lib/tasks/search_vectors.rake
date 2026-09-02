namespace :profiles do
  desc 'Rebuild the searchable tsvector column for every profile'
  task refresh_search_vectors: :environment do
    updated = Profile.refresh_search_vectors
    puts "Refreshed #{updated} profiles"
  end
end
