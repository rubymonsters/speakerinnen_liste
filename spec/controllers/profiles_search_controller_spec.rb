require 'spec_helper'

describe ProfilesSearchController, type: :controller do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Gertrud', lastname: 'Mueller', twitter: 'Apfel') }

  describe 'show' do
    it 'does not return profiles that do not match the given search string' do
      get :show, q: 'Horstin'
      expect(assigns(:results)).to be_empty
    end

    it 'does return profiles that match the lastname' do
      get :show, q: 'Muell'
      expect(assigns(:results)).to eq [profile]
    end

    it 'does return profiles that match the twittername' do
      get :show, q: 'apfel'
      expect(assigns(:results)).to eq [profile]
    end
  end
end
