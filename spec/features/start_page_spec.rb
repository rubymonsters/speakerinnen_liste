describe 'start page' do

  it 'shows start page in German' do
    visit '/de'

    expect(page).to have_content('Einloggen')
    expect(page).to have_content('Als Speakerin registrieren')
    expect(page).to have_content('Alle Speakerinnen* anschauen')
    expect(page).to have_content('Twitter')
    expect(page).to have_content('Impressum')
  end

  it 'shows start page in English' do
    visit root_path

    expect(page).to have_content('Log in')
    expect(page).to have_content('Register as a speaker')
    expect(page).to have_content('Twitter')
    expect(page).to have_content('Legal Details')
  end
end
