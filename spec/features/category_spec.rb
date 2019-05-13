RSpec.feature 'Category', type: :feature do
  describe 'when a category is assigned to tags' do

    let(:tag_fruehling) {ActsAsTaggableOn::Tag.find_by_name('fruehling')}
    let(:tag_sommer) {ActsAsTaggableOn::Tag.find_by_name('sommer')}
    let!(:category) { create(:cat_science) }

    before do
      FactoryBot.create(:ada, topic_list: ['fruehling'])
      FactoryBot.create(:marie, topic_list: ['fruehling', 'sommer'])
      tag_fruehling.categories << category
      tag_sommer.categories << category
    end

    it 'tags have the correct category' do
      expect(ActsAsTaggableOn::Tag.count).to equal(2)
      expect(tag_fruehling.categories.first.name).to eq(category.name)
      expect(Category.all.count).to equal(1)
    end

    it 'shows category in root path' do
      visit root_path
      expect(page).to have_content('Science')
    end
  end
end
