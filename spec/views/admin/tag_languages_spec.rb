include AuthHelper

describe 'admin navigation' do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }
  let!(:ada) { Profile.create!(FactoryGirl.attributes_for(:published, topic_list: ['algebra','algorithm','computer'])) }
  let!(:marie) { Profile.create!(FactoryGirl.attributes_for(:published, topic_list: ['radioactive','x-ray'])) }

  describe 'in tags' do
    before do
      sign_in admin
      click_on 'Admin'
      click_on 'Tags'
    end

    it 'should show all tags' do
      expect(page).to have_content('algebra')
      expect(page).to have_content('algorithm')
      expect(page).to have_content('computer')
      expect(page).to have_content('radioactive')
      expect(page).to have_content('x-ray')
    end
  end
end
