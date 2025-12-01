require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "#translations" do
    let(:category) { Category.new }

    it "creates for translation :en" do
      I18n.locale = :en
      category.name = "English Name"
      category.save
      expect(category.name).to eq "English Name"
      expect(category.translations.size).to eq(1)
      expect(category.translations.first.locale).to eq('en')
      expect(category.translations.first.name).to eq("English Name")
      expect(category.name_en).to eq("English Name")
      I18n.locale = :de
      expect(category.name).to eq "English Name" # fallback to en
    end

    it "creates for translation :de" do
      I18n.locale = :de
      category.name = "German Name"
      category.save
      expect(category.name).to eq "German Name"
      expect(category.translations.size).to eq(1)
      expect(category.translations.first.locale).to eq('de')
      expect(category.translations.first.name).to eq("German Name")
      expect(category.name_de).to eq("German Name")
      I18n.locale = :en
      expect(category.name).to eq "German Name" 
    end

    it "creates for translation :de and :en" do
      I18n.locale = :de
      category.name = "German Name"
      category.save
      expect(category.name).to eq "German Name"
      expect(category.translations.size).to eq(1)
      expect(category.translations.first.locale).to eq('de')
      expect(category.translations.first.name).to eq("German Name")
      expect(category.name_de).to eq("German Name")
      I18n.locale = :en
      expect(category.name).to eq "German Name" 
      category.name = "English Name"
      category.save
      expect(category.name).to eq "English Name"
      expect(category.translations.size).to eq(2)
    end
  end

  describe 'category order' do
    it "orders via the position field" do
      Category.create(name: "Art", position: 2)
      Category.create(name: "Career", position: 1)
      categories = Category.sorted_categories
      expect(categories.first.name).to eq 'Career'
      expect(categories.last.name).to eq 'Art'
    end
  end

end
