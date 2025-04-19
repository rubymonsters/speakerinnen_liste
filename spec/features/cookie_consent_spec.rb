RSpec.feature 'Cookie consent', type: :feature do

  let(:original_path) { root_path }

  scenario 'After consent given, redirects back without allow_cookies param' do
    visit original_path

    within(:css, 'div.cookie-consent-dialog') do
      expect(page).to have_text('you have to agree to the use of essential cookies')
      click_link 'I agree'
    end

    expect(page).to have_current_path(original_path)
  end
end
