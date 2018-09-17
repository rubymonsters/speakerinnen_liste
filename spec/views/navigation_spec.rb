# frozen_string_literal: true

shared_examples_for 'successful sign in' do
  it { should have_content(I18n.t('devise.sessions.signed_in')) }
  it { should have_link(I18n.t('layouts.application.logout')) }
end

describe 'navigation', broken: false do
  subject { page }

  before do
    @links_array = [admin_tags_path, admin_categories_path, admin_profiles_path]
    @lang_links_map = {
      'en' => %w[Categories Tags Profiles],
      'de' => %w[Kategorien Tags Profile]
    }
  end

  %w[en de].each do |language|
    describe 'go to the index page' do
      let!(:profile1) { FactoryBot.create(:published) }
      let!(:profile2) { FactoryBot.create(:published) }

      it 'should show the correct amount of speakerinnen' do
        visit "#{language}/profiles"
        expect(page).to have_content('2')
      end
    end

    context 'signed in as normal user' do
      let(:profile) { FactoryBot.create(:profile) }
      before do
        sign_in profile, language
      end

      it_should_behave_like 'successful sign in'
      it { should have_no_link('Admin') }
      it 'should lead to the show view of the profile' do
        expect(page).to have_content(profile.fullname)
        expect(page).to have_link(I18n.t('edit', scope: 'profiles.show'))
      end
    end

    context 'signed in as admin' do
      let(:admin) { FactoryBot.create(:admin) }
      before do
        sign_in admin, language
      end

      it_should_behave_like 'successful sign in'
      it { expect(page).to have_link('Admin') }

      describe 'access admin actions' do
        before { click_on 'Admin' }

        it { should have_content('Administration') }

        it 'should have localized links' do
          @lang_links_map[language].each_with_index do |link, _index|
            expect(page).to have_link(link)
          end
        end
      end
    end
  end
end
