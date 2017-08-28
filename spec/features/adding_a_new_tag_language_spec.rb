describe "adding a new tag_language" do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }

  before(:each) do
    sign_in admin
  end

  # click_link I18n.t(:tags, scope: "admin.dashboard.tags")

  # find(:css, "#profile_iso_languages_es").set(true)
end
