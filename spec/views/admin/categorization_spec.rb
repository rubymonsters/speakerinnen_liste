include AuthHelper

describe 'admin navigation' do
  let!(:admin) { FactoryGirl.create(:admin) }

  let!(:tag_physics) { FactoryGirl.create(:tag_physics) }
  let!(:tag_chemie) { FactoryGirl.create(:tag_chemie) }

  let!(:ada) { FactoryGirl.create(:published, topic_list: [tag_physics, tag_chemie]) }
  let!(:marie) { FactoryGirl.create(:published, topic_list: [tag_physics, tag_chemie]) }

  describe 'in tags' do
    before do
      sign_in admin
      click_on 'Admin'
      click_on 'Tags'
    end

    it 'shows all tags' do
      expect(page).to have_content('physics')
      expect(page).to have_content('chemie')
    end

    it 'shows section to filter categories' do
      expect(page).to have_css('.filter_categories')
    end

    it 'shows section to filter languages' do
      expect(page).to have_css('.filter_languages')
    end

    it 'should have checkboxes to filter languages' do
      expect(page).to have_css('input[type="checkbox"]')
    end
  end
end
