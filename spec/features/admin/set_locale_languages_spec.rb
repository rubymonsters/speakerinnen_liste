  describe 'set locale_language' do
    let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }

    before(:each) do
      sign_in admin
      visit admin_root_path
    end

    it 'adds a locale language to a tag'
      # expect(page).to have_link('Admin')
      # click_link I18n.t(:tags, scope: 'admin.dashboard.tags')
    # find(:css, "#profile_iso_languages_es").set(true)
  end
