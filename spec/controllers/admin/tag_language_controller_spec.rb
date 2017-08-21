include AuthHelper

describe Admin::TagLanguagesController, type: :controller do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }
  let!(:ada) { Profile.create!(FactoryGirl.attributes_for(:published, topic_list: ['algebra','algorithm','computer'])) }

  before(:each) do
    sign_in admin
  end

  describe 'GET tag_languages' do
    context 'without any selection' do
      before(:each) do
        get :tag_languages
      end

      specify { expect(response).to render_template(:tag_languages) }
      specify { expect(response.status).to eq 200 }

      # it 'should contain all tags' do
      #   expect(assigns(:tags)).to eq(
      #     [ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0]),
      #     ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[1]),
      #     ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[2]),
      #     ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[0]),
      #     ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1])]
      #     )
      # end
    end
  end

end
