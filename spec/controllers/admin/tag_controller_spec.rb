include AuthHelper

describe Admin::TagsController, type: :controller do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }
  let!(:non_admin) { Profile.create!(FactoryGirl.attributes_for(:published, topic_list: ['non_admin_topic1','non_admin_topic2'])) }


  before do
    sign_in admin
  end

  describe 'GET categorization' do
    context 'without any selection' do
      before do
        get :categorization
      end

      it 'should contain all tags' do
        expect(response).to render_template(:categorization)
        expect(response.status).to eq 200
        expect(assigns(:tags)).to eq(
          [ActsAsTaggableOn::Tag.find_by(name: non_admin.topic_list[0]),
          ActsAsTaggableOn::Tag.find_by(name: non_admin.topic_list[1])]
          )
      end
    end

    context 'select a category' do
      before do
        @categories = Category.new(name: 'Science')
        @tag = ActsAsTaggableOn::Tag.find_by(name: non_admin.topic[0])
        binding.pry

        @tag.categories << @category
        binding.pry
        get :categorization
      end
    end
  end

  describe 'GET edit' do
    before(:each) do
      sign_in admin
      topic = ActsAsTaggableOn::Tag.find_by(name: non_admin.topic_list[0])
      get :edit, id: topic.id
    end

    it 'renders the edit view' do
      expect(response).to render_template(:edit)
      expect(assigns(:tag)).to eq(ActsAsTaggableOn::Tag.find_by(name: non_admin.topic_list[0]))
    end

  end
end
