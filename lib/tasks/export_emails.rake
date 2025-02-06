namespace :export do
  desc "Export Profile firstnames, lastnames and emails to a CSV file"
  task profiles_to_csv: :environment do
    require 'csv'

    csv_data = 
      CSV.generate(headers: true) do |csv|
        # Write the header row
        csv << ["Firstname", "Lastname", "Email Address"]

        Profile.not_exported.is_published.find_each do |profile|
          csv << [profile.firstname, profile.lastname, profile.email]
          profile.update_column(:exported_at, Time.current)
        end
      end

    puts csv_data
  end
end