describe 'Requiring cookie consent' do

  it 'asks for cookie consent if no consent cookie is stored yet' do
    visit '/'
    click_link 'OK'

    expect(page).not_to have_css '.cookie-consent-dialog'
  end
end
