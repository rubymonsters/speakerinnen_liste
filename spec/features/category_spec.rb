RSpec.feature 'Category', type: :feature do
  describe 'when a category is assigned to tags' do

    let(:tag_fruehling) {ActsAsTaggableOn::Tag.find_by_name('fruehling')}
    let(:tag_sommer) {ActsAsTaggableOn::Tag.find_by_name('sommer')}

    before do
      FactoryBot.create(:ada, topic_list: ['fruehling'])
      FactoryBot.create(:marie, topic_list: ['fruehling', 'sommer'])
      category_jahreszeiten = Category.new(name: 'Jahreszeiten')
      category_jahreszeiten.save!
      tag_fruehling.categories << category_jahreszeiten
      tag_sommer.categories << category_jahreszeiten
    end

    it 'tags have the correct category' do
      expect(ActsAsTaggableOn::Tag.count).to equal(2)
      expect(tag_fruehling.categories.first.name).to eq('Jahreszeiten')
      expect(Category.all.count).to equal(1)
    end

    it 'shows category in root path' do
      visit root_path
      expect(page).to have_content('Jahreszeiten')
    end
  end
end
