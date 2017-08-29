RSpec.feature 'Navigation', type: :feature do
  describe 'adding and updating a tag_language' do
    let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }

    before(:each) do
      sign_in admin
    end

    context 'add a tag language to a tag'
      click_link I18n.t(:tags, scope: 'admin.dashboard.tags')
      save_and_open_page
    # find(:css, "#profile_iso_languages_es").set(true)
  end
end
