include AuthHelper

describe Admin::ProfilesController, type: :controller do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }
  let!(:admin_medialink) { FactoryGirl.create(:medialink, profile_id: admin.id) }
  let!(:non_admin) { Profile.create!(FactoryGirl.attributes_for(:published)) }
  let!(:non_admin_medialink) { FactoryGirl.create(:medialink, profile_id: non_admin.id) }

  describe 'GET index' do
    before(:each) do
      sign_in admin
      @profile = Profile.create!(FactoryGirl.attributes_for(:admin, firstname: 'Awe'))
      @profile1 = Profile.create!(FactoryGirl.attributes_for(:admin, firstname: 'NotInc'))
    end

    # describe 'when search param is provided' do
    #   before { get :index, search: 'Awe' }

    #   it 'should return success' do
    #     skip "ToDo: what is elasticsearch giving back?"
    #     expect(response.status).to eq 200
    #   end

    #   it 'should redirect to the admin profiles page' do
    #     expect(response).to render_template(:index)
    #   end

    #   it 'should contain queried results' do
    #     expect(assigns(:profiles)).to_not include(@profile1)
    #   end
    # end

    describe 'when search param is not provided' do
      before { get :index }

      it 'should return success' do
        expect(response.status).to eq 200
      end

      it 'should redirect to the admin profiles page' do
        expect(response).to render_template(:index)
      end

      it 'should contain all results' do
        expect(assigns(:profiles)).to include(@profile)
        expect(assigns(:profiles)).to include(@profile1)
      end
    end
  end

  describe 'GET show' do
    context 'when user is admin' do
      before(:each) do
        sign_in admin
        get :show, { id: non_admin.id }, format: :json
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
        get :show, id: admin.id
      end

      specify { expect(response.status).to eq 302 }
      specify { expect(response).to_not render_template(:show) }
      specify { expect(response).to redirect_to("/#{I18n.locale}/profiles") }
    end
  end

  describe 'GET edit' do
    context 'when user is admin' do
      before(:each) do
        sign_in admin
        get :edit, { id: non_admin.id }, format: :json
      end

      specify { expect(response.status).to eq 200 }
      specify { expect(response).to render_template(:edit) }

      it 'should edit the correct profile' do
        expect(assigns(:profile)).to eq(non_admin)
      end
    end

    context 'when user is not admin' do
      before(:each) do
        sign_in non_admin
        get :edit, id: admin.id
      end

      specify { expect(response.status).to eq 302 }
      specify { expect(response).to_not render_template(:edit) }
      specify { expect(response).to redirect_to("/#{I18n.locale}/profiles") }
    end
  end

  describe 'PUT update' do
    context 'when user is admin' do
      before(:each) do
        sign_in admin
        @old_mail = non_admin.email
      end

      describe 'when valid params are supplied' do
        before { put :update, id: non_admin.id, profile: { firstname: 'marie', lastname: 'curie' } }

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
        before { put :update, id: non_admin.id, profile: { email: ' ' } }

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
        put :update, id: admin.id, profile: { firstname: 'marie' }
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
          delete :destroy, id: non_admin.id
        end.to change(Profile, :count).by(-1)
      end

      it 'should not find the destroyed user' do
        delete :destroy, id: non_admin.id
        expect { Profile.find(non_admin.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it 'should return 302 response status' do
        delete :destroy, id: non_admin.id
        expect(response.status).to eq 302
      end
    end

    context 'When user is a non-admin' do
      before(:each) do
        sign_in non_admin
        delete :destroy, id: admin.id
      end

      specify { expect(response.status).to eq 302 }
      it 'should not destroy the requested Profile' do
        expect(Profile.where(id: admin.id).count).to eq 1
      end
    end
  end

  describe 'POST published' do
    before { @unpublished = FactoryGirl.create(:unpublished) }

    context 'When user is admin' do
      before(:each) do
        sign_in admin
        post :publish, id: @unpublished.id
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
        post :publish, id: @unpublished.id
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
    before { @published = FactoryGirl.create(:published) }

    context 'When user is admin' do
      before(:each) do
        sign_in admin
        post :unpublish, id: @published.id
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
        post :unpublish, id: @published.id
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
