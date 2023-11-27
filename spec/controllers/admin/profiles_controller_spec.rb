# frozen_string_literal: true

describe Admin::ProfilesController, type: :controller do
  include AuthHelper

  let!(:admin) { FactoryBot.create(:admin) }
  let!(:admin_medialink) { FactoryBot.create(:medialink, profile_id: admin.id) }
  let!(:non_admin) { FactoryBot.create(:published_profile) }
  let!(:non_admin_medialink) do
    FactoryBot.create(:medialink,
                      profile_id: non_admin.id,
                      title: 'Ada and the computer',
                      url: 'www.adalovelace.de',
                      description: 'How to program')
  end

  describe 'GET index' do
    before(:each) do
      sign_in admin
      @profile = FactoryBot.create(:profile, firstname: 'Awe', published: true)
      @profile1 = FactoryBot.create(:profile, firstname: 'NotInc', published: true)
    end

    describe 'when search param is provided' do
      before { get :index, params: { search: 'Awe' } }

      it 'should return success' do
        expect(response.status).to eq 200
      end

      it 'should redirect to the admin profiles page' do
        expect(response).to render_template(:index)
      end

      it 'should contain queried results' do
        expect(assigns(:records)).to_not include(@profile1)
      end
    end

    describe 'when search param is not provided' do
      before { get :index }

      it 'should return success' do
        expect(response.status).to eq 200
      end

      it 'should redirect to the admin profiles page' do
        expect(response).to render_template(:index)
      end

      it 'should contain all results' do
        expect(assigns(:records).count).to eq 4
      end
    end
  end

  describe 'GET show' do
    context 'when user is admin' do
      before(:each) do
        sign_in admin
        get :show, params: { id: non_admin.id }
      end

      specify { expect(response.status).to eq 200 }
      specify { expect(response).to render_template(:show) }

      it 'gets the requested profile' do
        expect(assigns(:profile)).to eq(non_admin)
      end

      it 'fetches all medialinks for the requested profile' do
        expect(assigns(:medialinks)).to include(non_admin_medialink)
      end
    end

    context 'when user is not admin' do
      before(:each) do
        sign_in non_admin
        get :show, params: { id: admin.id }
      end

      specify { expect(response.status).to eq 302 }
      specify { expect(response).to_not render_template(:show) }
      specify { expect(response).to redirect_to("/#{I18n.locale}/profiles") }
    end
  end

  describe 'GET edit' do
    context 'when user is admin they can edit any profile' do
      before(:each) do
        sign_in admin
        get :edit, params: { id: non_admin.id }
      end

      specify { expect(response.status).to eq 200 }
      specify { expect(response).to render_template(:edit) }

      it 'should edit the correct profile' do
        expect(assigns(:profile)).to eq(non_admin)
      end

      it 'fetches all medialinks for the requested profile' do
        expect(assigns(:profile).medialinks).to include(non_admin_medialink)
      end
    end

    context 'when user is not admin they can edit only their own profile' do
      before(:each) do
        sign_in non_admin
        get :edit, params: { id: admin.id }
      end

      specify { expect(response.status).to eq 302 }
      specify { expect(response).to_not render_template(:edit) }
      specify { expect(response).to redirect_to("/#{I18n.locale}/profiles") }
    end
  end

  describe 'PUT admin_update' do
    before(:each) do
      sign_in admin
    end

    it 'redirects to same page in profiles list' do
      put :admin_update, params: { id: non_admin.id, profile: { admin_comment: "this is a comment" }, page: 2 }
      expect(response).to redirect_to("/#{I18n.locale}/admin/profiles?page=2")
    end

    it 'redirects to first page in profiles list' do
      put :admin_update, params: { id: non_admin.id, profile: { admin_comment: "this is a comment" } }
      expect(response).to redirect_to("/#{I18n.locale}/admin/profiles")
    end

    it 'redirects to profile view page' do
      put :admin_update, params: { id: non_admin.id, profile: { admin_comment: "this is a comment" }, page: 'show' }
      expect(response).to redirect_to("/#{I18n.locale}/admin/profiles/#{non_admin.slug}")
    end

    it 'redirects to profile edit page' do
      put :admin_update, params: { id: non_admin.id, profile: { admin_comment: "this is a comment" }, page: 'edit' }
      expect(response).to redirect_to("/#{I18n.locale}/admin/profiles/#{non_admin.slug}/edit")
    end
  end

  describe 'PUT update' do
    context 'when user is admin' do
      before(:each) do
        sign_in admin
        @old_mail = non_admin.email
      end

      describe 'when valid params are supplied' do
        before { put :update, params: { id: non_admin.id, profile: { firstname: 'marie', lastname: 'curie' } } }

        it 'should return a 302 status response' do
          expect(response.status).to eq 302
        end

        it 'should update the requested Profile' do
          non_admin.reload
          expect(non_admin.firstname).to eq 'marie'
        end

        it 'should redirect to the updated profile' do
          expect(response).to redirect_to("/#{I18n.locale}/admin/profiles/marie-curie")
        end
      end

      describe 'when invalid params are supplied' do
        before { put :update, params: { id: non_admin.id, profile: { email: ' ' } } }

        it 'should return a 200 status response' do
          expect(response.status).to eq 200
        end

        it 'should not update the requested Profile' do
          non_admin.reload
          expect(non_admin.email).to eq @old_mail
        end

        it 'should render the edit template' do
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user is not admin' do
      before(:each) do
        sign_in non_admin
        put :update, params: { id: admin.id, profile: { firstname: 'marie' } }
      end

      specify { expect(response.status).to eq 302 }
      specify { expect(response).to redirect_to("/#{I18n.locale}/profiles") }
    end
  end

  describe 'DELETE destroy' do
    context 'When user is an admin' do
      before(:each) do
        sign_in admin
      end

      it 'should destroy requested profile' do
        expect do
          delete :destroy, params: { id: non_admin.id }
        end.to change(Profile, :count).by(-1)
      end

      it 'should not find the destroyed user' do
        delete :destroy, params: { id: non_admin.id }
        expect { Profile.find(non_admin.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it 'should return 302 response status' do
        delete :destroy, params: { id: non_admin.id }
        expect(response.status).to eq 302
      end
    end

    context 'When user is a non-admin' do
      before(:each) do
        sign_in non_admin
        delete :destroy, params: { id: admin.id }
      end

      specify { expect(response.status).to eq 302 }
      it 'should not destroy the requested Profile' do
        expect(Profile.where(id: admin.id).count).to eq 1
      end
    end
  end

  describe 'POST published' do
    before { @unpublished = FactoryBot.create(:unpublished_profile) }

    context 'When user is admin' do
      before(:each) do
        sign_in admin
        post :publish, params: { id: @unpublished.id }
      end

      it 'should return 302 status response' do
        expect(response.status).to eq 302
      end

      it 'should change Profile status to published' do
        @unpublished.reload
        expect(@unpublished.published).to be true
      end

      it 'should redirect to the admin profiles page' do
        expect(response).to redirect_to("/#{I18n.locale}/admin/profiles")
      end
    end

    context 'When user is a non_admin' do
      before(:each) do
        sign_in non_admin
        post :publish, params: { id: @unpublished.id }
      end

      it 'should return 302 status response' do
        expect(response.status).to eq 302
      end

      it 'should not change published profile' do
        @unpublished.reload
        expect(@unpublished.published).to be false
      end

      it 'should redirect to the admin profiles page' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end
  end

  describe 'POST unpublished' do
    before { @published = FactoryBot.create(:published_profile) }

    context 'When user is admin' do
      before(:each) do
        sign_in admin
        post :unpublish, params: { id: @published.id }
      end

      it 'should return 302 status response' do
        expect(response.status).to eq 302
      end

      it 'should not change the profiles page to published' do
        @published.reload
        expect(@published.published).to be false
      end
      it 'should redirect_to admin profiles page' do
        expect(response).to redirect_to("/#{I18n.locale}/admin/profiles")
      end
    end

    context 'When user is a non_admin' do
      before(:each) do
        sign_in non_admin
        post :unpublish, params: { id: @published.id }
      end

      it 'should return 302 status response' do
        expect(response.status).to eq 302
      end

      it 'should not change published profile' do
        @published.reload
        expect(@published.published).to be true
      end

      it 'should redirect to the user profiles page' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end
  end
end
