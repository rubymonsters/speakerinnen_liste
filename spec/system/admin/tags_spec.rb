# frozen_string_literal: true

describe 'in tags' do
  let!(:admin) { FactoryBot.create(:admin) }

  let!(:locale_language_de) { FactoryBot.create(:locale_language_de) }
  let!(:locale_language_en) { FactoryBot.create(:locale_language_en) }

  let(:category) { FactoryBot.create(:cat_science, id: 999) }
  let!(:tag_chemie) { FactoryBot.create(:tag_chemie) }
  let!(:tag_physics) { FactoryBot.create(:tag_physics, categories: [category]) }
  let!(:tag_with_slash_en) { create(:tag, name: 'AC/DC', locale_languages: [locale_language_en]) }

  before do
    create(:ada, topic_list: [tag_physics, tag_chemie])
    create(:marie, topic_list: [tag_physics, tag_chemie])
    sign_in admin
    visit admin_root_path
    click_link I18n.t(:tags, scope: 'admin.tags')
  end

  context 'when presenting the tag overview' do
    it 'shows the tag editing functions' do
      expect(page).to have_text('Administration::Tags')
      expect(page).to have_text('Search')
      expect(page).to have_button('Filter')
    end

    it 'presents correct locale language for a tags' do
      expect(page).to have_content('AC/DC')
      expect(page.html).to include('English<br/>')
      expect(page.html).to_not include('German<br/>')
    end

    it 'shows all tags' do
      expect(page).to have_content('AC/DC')
      expect(page).to have_content('physics')
      expect(page).to have_content('chemie')
    end
  end

  context 'when editing a tag' do
    it 'adds a locale_language to tags' do
      click_link tag_chemie.name
      expect(page).to have_selector("input[value='chemie']")
      expect(page).to_not have_checked_field("#{tag_chemie.id}_en")
      expect(page).to_not have_checked_field("#{tag_chemie.id}_de")
      check "#{tag_chemie.id}_en"
      click_button 'Save'
      expect(page.html).to include('English<br/>')
      expect(page.html).to_not include('German<br/>')
      expect(tag_chemie.locale_languages.first.iso_code).to eq('en')
    end

    it 'assigns a category to a tag' do
      click_link tag_chemie.name
      expect(page).to_not have_checked_field("#{tag_chemie.id}_#{category.id}")

      check "#{tag_chemie.id}_#{category.id}"
      click_button 'Save'
      expect(tag_chemie.categories.first.name).to eq 'Science'
    end

    it 'updates a tag name' do
      click_link tag_chemie.name
      fill_in 'tag_name', with: 'Lieblingsfach Chemie'
      click_button 'Save'

      expect(page).to have_current_path(admin_tags_path(locale: :en))
      expect(page).to have_content('Lieblingsfach Chemie')
    end
  end

  context 'when filtering for tags' do
    it 'filters tags by categories' do
      within '.filter_categories' do
        choose 'Science'
      end

      click_button 'Filter/ Search'

      expect(page).to have_content('physics')
      expect(page).not_to have_content('chemie')

    end

    it 'shows section to filter languages' do
      expect(page).to have_css('.filter_languages')
    end

    it 'should have checkboxes to filter languages' do
      expect(page).to have_css('input[type="checkbox"]')
    end
  end

  context 'when searching for tags' do
    it 'finds tags that are not assigned a category' do
      within '.search' do
        fill_in 'q', with: 'che'
      end

      click_button 'Filter/ Search'
      expect(page).to have_content('chemie')
    end

    it 'searches only in uncategorized topics if selected' do
      another_tag_with_che = create(
        :tag,
        name: 'che sera sera',
        categories: [category]
      )

      within '.filter_categories' do
        choose 'Tags without category'
      end

      within '.search' do
        fill_in 'q', with: 'che'
      end

      click_button 'Filter/ Search'
      expect(page).not_to have_content('physics')
      expect(page).not_to have_content(another_tag_with_che.name)
    end
  end
end
