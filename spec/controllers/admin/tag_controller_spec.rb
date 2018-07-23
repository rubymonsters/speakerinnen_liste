# frozen_string_literal: true

include AuthHelper

describe Admin::TagsController, type: :controller do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:ada) { FactoryBot.create(:published, topic_list: %w[algebra algorithm computer]) }
  let!(:marie) { FactoryBot.create(:published, topic_list: ['radioactive', 'x-ray']) }

  before(:each) do
    sign_in admin
  end

  describe 'GET index' do
    context 'without any selection' do
      before(:each) do
        get :index
      end

      specify { expect(response).to render_template(:index) }
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
        get :index, params: { category_id: category.id }
      end

      specify { expect(response).to render_template(:index) }

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
        get :index, params: { q: 'alg' }
      end

      specify { expect(response).to render_template(:index) }

      it 'find the correct topic' do
        expect(assigns(:tags)).to eq(
          [ActsAsTaggableOn::Tag.find_by(name: 'algebra'),
           ActsAsTaggableOn::Tag.find_by(name: 'algorithm')]
        )
      end
    end

    context 'searches only for uncategorized topics' do
      before(:each) do
        category = Category.new(name: 'Science')
        category.save!
        ada_tag = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
        ada_tag.categories << category
        get :index, params: { q: 'alg', uncategorized: true }
      end

      specify { expect(response).to render_template(:index) }

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
        get :index, params: { uncategorized: true }
      end

      specify { expect(response).to render_template(:index) }
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

  describe 'GET tag_language' do
    context 'without any selection' do
      before(:each) do
        get :index
      end

      specify { expect(response).to render_template(:index) }
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
  end

  describe 'GET edit' do
    before(:each) do
      topic = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
      get :edit, params: { id: topic.id }
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
          put :update, params: { id: @wrong_topic.id, tag: { name: 'mathematic' } }
        end

        specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index") }
        it 'changes the topic name' do
          expect(ActsAsTaggableOn::Tag.find(@wrong_topic.id).name).to eq('mathematic')
        end
      end

      context 'topic name already exist' do
        before(:each) do
          put :update, params: { id: @wrong_topic.id, tag: { name: 'radioactive' } }
        end

        specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index") }
        it 'deletes the wrong topic and adds a new tagging' do
          expect(ActsAsTaggableOn::Tag.find_by(name: 'algebra')).to be_nil
          expect(ActsAsTaggableOn::Tag.find_by(name: 'radioactive')).to be_truthy
          expect(ActsAsTaggableOn::Tagging.count).to be 5
          expect(ActsAsTaggableOn::Tag.count).to be 4
        end
      end
    end

    context '#set_tag_languages' do
      let!(:locale_language) { LocaleLanguage.create(iso_code: 'en') }
      let(:tag) { ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[0]) }

      it 'assings a language to the topic' do
        # should be --> put :update, params: { languages: ['en'], id: tag.id } but test fails then
        put :update, params: { languages: ['en'], id: tag.id }
        expect(tag.locale_languages.first.iso_code).to match('en')
      end

      it 'remove a language from the topic' do
        tag.locale_languages << locale_language
        put :update, params: { id: tag.id }
        # have to reaload tag to get the new relations
        tag = ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[0])
        expect(tag.locale_languages).to match([])
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
        post :set_category, params: { id: @tag.id, category_id: @category.id }
      end

      specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index") }
      it 'category gets assigned to a topic' do
        expect(assigns(:tag).categories.first.name).to eq 'Science'
      end
    end

    context 'removes_category' do
      before(:each) do
        @tag.categories << @category
        # should be --> post :remove_category, params: { id: @tag.id, category_id: @category.id }
        post :remove_category, params: { id: @tag.id, category_id: @category.id }
      end

      specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index") }
      it 'assigned categories gets removed from a topic' do
        expect(assigns(:tag).categories).to be_empty
      end
    end
  end

  describe 'DELETE topic' do
    context 'topic' do
      before(:each) do
        @tag = ActsAsTaggableOn::Tag.find_by_name('algorithm')
        # should be --> delete :destroy, params: { id: @tag.id }
        delete :destroy, params: { id: @tag.id }
      end

      it 'should not find the destroyed tag' do
        expect { ActsAsTaggableOn::Tag.find(@tag.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'keep selected filters from index page' do
    let(:category) { Category.create(name: 'Science') }
    let(:ada_tag) { ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0]) }
    let(:marie_tag) { ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1]) }

    before(:each) do
      LocaleLanguage.create(iso_code: 'en')
      ada_tag.categories << category
      marie_tag.categories << category
      session[:filter_params] = nil
      get :index, params: { category_id: category.id }
    end

    context 'after updating a tag name' do
      before do
        put :update, params: { id: category.id, tag: { name: 'mathematic' } }
      end

      specify {expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index?category_id=#{category.id}")}
    end

    context 'after updating a tag language' do
      before do
        put :update, params: { languages: ['en'], id: ada_tag.id }
      end

      specify {expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index?category_id=#{category.id}#top-anchor")}
    end

    context 'after deleting a tag' do
      before do
        delete :destroy, params: { id: ada_tag.id }
      end

      specify {expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index?category_id=#{category.id}")}
    end

    context 'after seting a category' do
      before do
        post :set_category, params: { id: ada_tag.id, category_id: category.id }
      end

      specify {expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index?category_id=#{category.id}")}
    end

    context 'after removing a category' do
      before do
        post :remove_category, params: { id: ada_tag.id, category_id: category.id }
      end

      specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index?category_id=#{category.id}")}
    end
  end
end
