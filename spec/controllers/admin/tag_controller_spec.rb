include AuthHelper

describe Admin::TagsController, type: :controller do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }
  let!(:ada) { Profile.create!(FactoryGirl.attributes_for(:published, topic_list: ['algebra','algorithm','computer'])) }
  let!(:marie) { Profile.create!(FactoryGirl.attributes_for(:published, topic_list: ['radioactive','x-ray'])) }


  before do
    sign_in admin
  end

  describe 'GET categorization' do
    context 'without any selection' do
      before(:each) do
        get :categorization
      end

      specify { expect(response).to render_template(:categorization) }
      specify { expect(response.status).to eq 200 }

      it 'should contain all tags' do
        expect(assigns(:tags)).to eq(
          [ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0]),
          ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[1]),
          ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[2]),
          ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[0]),
          ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1])]
          )
      end
    end

    context 'select a category' do
      before(:each) do
        category = Category.new(name: 'Science')
        category.save!
        ada_tag = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
        marie_tag = ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1])
        ada_tag.categories << category
        marie_tag.categories << category
        get :categorization, category_id: category.id
      end

      specify { expect(response).to render_template(:categorization) }

      it 'find only the topic associated with the category' do
        expect(assigns(:tags)).to eq(
          [ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0]),
          ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1])]
          )
      end

      it 'find not the topics that is not associated with the category' do
        expect(assigns(:tags)).to_not eq([ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[1])])
        expect(assigns(:tags)).to_not eq([ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[2])])
        expect(assigns(:tags)).to_not eq([ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[0])])
      end
    end

    context 'searches for topics no matter if they are assigned to a category' do
      before(:each) do
        get :categorization, q: 'alg'
      end

      specify { expect(response).to render_template(:categorization) }

      it 'find the correct topic' do
        expect(assigns(:tags)).to eq(
          [ActsAsTaggableOn::Tag.find_by(name: 'algebra'),
          ActsAsTaggableOn::Tag.find_by(name: 'algorithm')
          ])
      end
    end

    context 'searches only for uncategorized topics' do
      before(:each) do
        category = Category.new(name: 'Science')
        category.save!
        ada_tag = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
        ada_tag.categories << category
        get :categorization, { q: 'alg', uncategorized: true }
      end

      specify { expect(response).to render_template(:categorization) }

      it 'finds the uncategorized topic' do
        expect(assigns(:tags)).to eq([ActsAsTaggableOn::Tag.find_by(name: 'algorithm')])
      end

      it 'does not find the categorized topics' do
        expect(assigns(:tags)).to_not eq([ActsAsTaggableOn::Tag.find_by(name: 'algebra')])
      end
    end

    context 'select uncategorized' do
      before(:each) do
        category = Category.new(name: 'Science')
        category.save!
        tag = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
        tag.categories << category
        get :categorization, uncategorized: true
      end

      specify { expect(response).to render_template(:categorization) }

      it 'finds only uncategorized topics' do
        expect(assigns(:tags)).to eq([
          ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[1]),
          ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[2]),
          ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[0]),
          ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1])
          ])
      end

      it 'does not categorized topics' do
        expect(assigns(:tags)).to_not eq([ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])])
      end
    end

  end

  describe 'GET edit' do
    before(:each) do
      sign_in admin
      topic = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
      get :edit, id: topic.id
    end

    specify { expect(response).to render_template(:edit) }

    it 'renders the edit view' do
      expect(assigns(:tag)).to eq(ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0]))
    end

  end
end
