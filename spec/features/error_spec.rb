describe "ErrorHandling" do
  it 'renders not_found template' do
    visit '/blah'
    expect(page).to have_content "We are sorry, but you must have missspelled the URL, there is no page here."
  end
end
