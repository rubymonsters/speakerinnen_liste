HoneycombRails.configure do |conf|
  conf.writekey = <%= ENV['HONEYCOMB_API_KEY'] %>
  conf.dataset = 'rails-dataset'
  conf.db_dataset = 'db-dataset'
end