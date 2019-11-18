# frozen_string_literal: true

desc 'migrates existing pictures from carriewave to active storage'
task carrierwave_to_active_storage: :environment do
  Profile.find_each do |profile|
    begin
      if profile.picture.present? && profile.picture.file.present?
        if profile.image.attached?
          puts profile.image.name
        else
          profile.image.attach(io: open(profile.picture.url), filename: profile.picture.file.filename )
          # profile.picture.file.filename is for example: demosthenes_louvre.jpg
          puts profile.picture.file.filename
          # profile.picture.file.path is for example: /Users/sabrina/projects/speakerinnen_liste/public/uploads/profile/picture/498/demosthenes_louvre.jpg
          # puts profile.picture.file.path
          # profile.picture.url is for example: /uploads/profile/picture/498/demosthenes_louvre.jpg
          puts profile.picture.url
        end
      end
    rescue => e
      puts "exeption: #{e}"
    end
  end
end
