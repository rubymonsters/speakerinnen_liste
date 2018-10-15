# frozen_string_literal: true

describe 'Requiring cookie consent' do
  it 'asks for cookie consent if no consent cookie is stored yet' do
    visit '/'
    click_link('I agree', match: :first)

    expect(page).not_to have_css '.cookie-consent-dialog'
  end
end
