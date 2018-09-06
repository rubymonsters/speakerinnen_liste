RSpec.feature 'Cookie consent', type: :feature do
  
  let(:original_path) { root_path }
  
  scenario 'After consent given, redirects back without allow_cookies param' do
    visit original_path

    within(:css, 'div.cookie-consent-dialog') do
      expect(page).to have_text('By using this website, you agree to the use of cookies')
      click_link 'OK'
    end
    
    expect(page).to have_current_path(original_path)
  end
end
