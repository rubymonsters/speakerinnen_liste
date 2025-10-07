namespace :db do
  desc 'Fill database with sample categories'
  task populate_categories: :environment do
    if Category.count == 0
       cat             = Category.create(name: "Bildung", position:1 )
       cat.name_de     = "Beruf & Bildung"
       cat.name_en     = "Career & Education"
       cat.save!
      cat         = Category.create(name: "Diversität", position:2)
      cat.name_de = "Diversität"
      cat.name_en = "Diversity"
      cat.save!
      cat = Category.create(name: "Politik & Gesellschaft", position:3)
      cat.name_de = "Politik & Gesellschaft"
      cat.name_en = "Politics & Society"
      cat.save!
    end
  end
end
