include AuthHelper

describe Admin::TagsController, type: :controller do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }
  let!(:ada) { Profile.create!(FactoryGirl.attributes_for(:published, topic_list: %w('algebra' 'algorithm' 'computer'))) }
  let!(:marie) { Profile.create!(FactoryGirl.attributes_for(:published, topic_list: ['radioactive', 'x-ray'])) }

  before(:each) do
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
           ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1])])
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
           ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1])])
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
           ActsAsTaggableOn::Tag.find_by(name: 'algorithm')])
      end
    end

    context 'searches only for uncategorized topics' do
      before(:each) do
        category = Category.new(name: 'Science')
        category.save!
        ada_tag = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
        ada_tag.categories << category
        get :categorization, q: 'alg', uncategorized: true
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
          ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1])])
      end

      it 'does not categorized topics' do
        expect(assigns(:tags)).to_not eq([ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])])
      end
    end
  end

  describe 'GET edit' do
    before(:each) do
      topic = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
      get :edit, id: topic.id
    end

    specify { expect(response).to render_template(:edit) }
    it 'renders the edit view' do
      expect(assigns(:tag)).to eq(ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0]))
    end
  end

  describe 'PUT update' do
    context 'rename the topic' do
      before(:each) do
        @wrong_topic = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
      end

      context 'topic name is unique' do
        before(:each) do
          put :update, id: @wrong_topic.id, tag: { name: 'mathematic' }
        end

        specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/categorization") }
        it 'changes the topic name' do
          expect(ActsAsTaggableOn::Tag.find(@wrong_topic.id).name).to eq('mathematic')
        end
      end

      context 'topic name already exist' do
        before(:each) do
          put :update, id: @wrong_topic.id, tag: { name: 'radioactive' }
        end

        specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/categorization") }
        it 'deletes the wrong topic and adds a new tagging' do
          expect(ActsAsTaggableOn::Tag.find_by(name: 'algebra')).to be_nil
          expect(ActsAsTaggableOn::Tag.find_by(name: 'radioactive')).to be_truthy
          expect(ActsAsTaggableOn::Tagging.count).to be 5
          expect(ActsAsTaggableOn::Tag.count).to be 4
        end
      end
    end
  end

  describe 'POST' do
    before(:each) do
      @tag = ActsAsTaggableOn::Tag.find_by_name('algorithm')
      @category = Category.create!(name: 'Science')
    end

    context 'set_category' do
      before(:each) do
        post :set_category, id: @tag.id, category_id: @category.id
      end

      specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/categorization") }
      it 'category gets assigned to a topic' do
        expect(assigns(:tag).categories.first.name).to eq 'Science'
      end
    end

    context 'removes_category' do
      before(:each) do
        @tag.categories << @category
        post :remove_category, id: @tag.id, category_id: @category.id
      end

      specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/categorization") }
      it 'assigned categories gets removed from a topic' do
        expect(assigns(:tag).categories).to be_empty
      end
    end
  end

  describe 'DELETE topic' do
    context 'topic' do
      before(:each) do
        @tag = ActsAsTaggableOn::Tag.find_by_name('algorithm')
        delete :destroy, id: @tag.id
      end

      it 'should not find the destroyed tag' do
        expect { ActsAsTaggableOn::Tag.find(@tag.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
