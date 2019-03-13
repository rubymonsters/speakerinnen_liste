# frozen_string_literal: true

describe Admin::TagsController, type: :controller do
  include AuthHelper

  let(:admin) { FactoryBot.create(:admin) }
  let!(:ada) { FactoryBot.create(:ada, topic_list: %w[algebra algorithm computer]) }
  let!(:marie) { FactoryBot.create(:marie, topic_list: ['radioactive', 'x-ray']) }

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
        get :index, params: { q: 'alg', category_id: 'uncategorized' }
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
        get :index, params: { category_id: 'uncategorized' }
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

    context 'searches only for categorized topics' do
      before(:each) do
        category = Category.new(name: 'Science')
        category.save!
        ada_tag = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
        ada_tag.categories << category
        get :index, params: { q: 'alg', category_id: 'categorized' }
      end

      specify { expect(response).to render_template(:index) }

      it 'does not find the uncategorized topic' do
        expect(assigns(:tags)).to_not eq([ActsAsTaggableOn::Tag.find_by(name: 'algorithm')])
      end

      it 'finds the categorized topics' do
        expect(assigns(:tags)).to eq([ActsAsTaggableOn::Tag.find_by(name: 'algebra')])
      end
    end

    context 'select categorized' do
      before(:each) do
        category = Category.new(name: 'Science')
        category.save!
        tag1 = ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0])
        tag2 = ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[0])
        tag1.categories << category
        tag2.categories << category
        get :index, params: { category_id: 'categorized' }
      end

      specify { expect(response).to render_template(:index) }
      it 'finds only categorized topics' do
        expect(assigns(:tags)).to eq([
                                       ActsAsTaggableOn::Tag.find_by(name: 'algebra'),
                                       ActsAsTaggableOn::Tag.find_by(name: 'radioactive'),
                                     ])
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
    let(:name) {marie.topic_list[0]}
    let(:tag) { ActsAsTaggableOn::Tag.find_by(name: name) }

    context 'update a tag with a unique name' do
      it 'redirects to index page after submit' do
        put :update, params: { tag: { name: tag.name, languages: [], categories: [] }, id: tag.id }
        expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index#tag_#{tag.id}")
      end

      context 'tag name' do
        it 'changes the tags name whan tag name is changed' do
          put :update, params: { tag: { name: 'rediation',  languages: [], categories: [] }, id: tag.id }
          expect(ActsAsTaggableOn::Tag.find(tag.id).name).to eq('rediation')
        end

        it 'does nothing when tag name is not changed' do
          put :update, params: { tag: { name: tag.name, languages: [], categories: [] }, id: tag.id }
          expect(ActsAsTaggableOn::Tag.find(tag.id).name).to eq('radioactive')
        end
      end

      context 'tag languages' do
        let!(:locale_language) { LocaleLanguage.create(iso_code: 'en') }

        it 'assings a language to a tag when language is selected' do
          put :update, params: {tag: {name: tag.name, languages: ['en'], categories: []}, id: tag.id }
          expect(tag.locale_languages.first.iso_code).to match('en')
        end

        it 'removes a language from a tag whan language is unselected' do
          tag.locale_languages << locale_language
          put :update, params: { tag: {name: tag.name, languages: [], categories: []}, id: tag.id }
          # have to reaload tag to get the new relations
          tag = ActsAsTaggableOn::Tag.find_by(name: name)
          expect(tag.locale_languages).to match([])
        end

        it 'does nothing when languages are not changed' do
          tag.locale_languages << locale_language
          put :update, params: { tag: {name: tag.name, languages: ['en'], categories: [] }, id: tag.id }
          # have to reaload tag to get the new relations
          tag = ActsAsTaggableOn::Tag.find_by(name: name)
          expect(tag.locale_languages.first.iso_code).to match('en')
        end
      end

      context 'tag categories' do
        let(:category) { Category.create!(name: 'Science') }

        it 'assigns category to a tag whan category is selected' do
          put :update, params: { tag: { name: tag.name, languages: [], categories: [category.id] }, id: tag.id }
          expect(assigns(:tag).categories.first.name).to eq 'Science'
        end

        it 'removes assigned categories from a tag when category is unselected' do
          tag.categories << category
          put :update, params: { tag: { neme: tag.name, languages: [], categories: [] }, id: tag.id }
          expect(assigns(:tag).categories).to be_empty
        end

        it 'does nothing when categories are not changed' do
          tag.categories << category
          put :update, params: {tag: {name: tag.name, languages: [], categories: [category.id]}, id: tag.id }
          expect(assigns(:tag).categories.first.name).to eq 'Science'
        end
      end
    end

    context 'update a tag when tag name already exist' do
      it 'redirects to index page when after submit' do
        put :update, params: { tag: { name: tag.name, languages: [], categories: [] }, id: tag.id }
        expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index#tag_#{tag.id}")
      end

      context 'tag name' do
        before(:each) do
          put :update, params: { id: tag.id, tag: { name: 'algebra', languages: [], categories: [] } }
        end

        it 'deletes the tag and adds a new tagging' do
          expect(ActsAsTaggableOn::Tag.find_by(name: 'radioactive')).to be_nil
          expect(ActsAsTaggableOn::Tag.find_by(name: 'algebra')).to be_truthy
          expect(ActsAsTaggableOn::Tagging.count).to be 5
          expect(ActsAsTaggableOn::Tag.count).to be 4
        end
      end

      context 'tag languages' do
        let!(:locale_language) { LocaleLanguage.create(iso_code: 'en') }

        it 'assings a language to a tag when language is selected' do
          put :update, params: { tag: { name: tag.name, languages: ['en'], categories: [] }, id: tag.id }
          expect(tag.locale_languages.first.iso_code).to match('en')
        end

        it 'removes a language from a tag whan language is unselected' do
          tag.locale_languages << locale_language
          put :update, params: { tag: { name: tag.name, languages: [], categories: [] }, id: tag.id }
          # have to reaload tag to get the new relations
          tag = ActsAsTaggableOn::Tag.find_by(name: name)
          expect(tag.locale_languages).to match([])
        end

        it 'does nothing when languages are not changed' do
          tag.locale_languages << locale_language
          put :update, params: { tag: { name: tag.name, languages: ['en'], categories: [] }, id: tag.id }
          # have to reaload tag to get the new relations
          tag = ActsAsTaggableOn::Tag.find_by(name: name)
          expect(tag.locale_languages.first.iso_code).to match('en')
        end
      end

      context 'tag categories' do
        let(:category) { Category.create!(name: 'Science') }

        it 'assigns category to a tag whan category is selected' do
          put :update, params: { tag: { name: tag.name, languages: [], categories: [category.id] }, id: tag.id }
          expect(assigns(:tag).categories.first.name).to eq 'Science'
        end

        it 'removes assigned categories from a tag when category is unselected' do
          tag.categories << category
          put :update, params: { tag: { neme: tag.name, languages: [], categories: [] }, id: tag.id }
          expect(assigns(:tag).categories).to be_empty
        end

        it 'does nothing when categories are not changed' do
          tag.categories << category
          put :update, params: {tag: {name: tag.name, languages: [], categories: [category.id]}, id: tag.id,  }
          expect(assigns(:tag).categories.first.name).to eq 'Science'
        end
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
    let(:category) { Category.create!(name: 'Science') }
    let(:ada_tag) { ActsAsTaggableOn::Tag.find_by(name: ada.topic_list[0]) }
    let(:marie_tag) { ActsAsTaggableOn::Tag.find_by(name: marie.topic_list[1]) }

    before(:each) do
      LocaleLanguage.create!(iso_code: 'en')
      ada_tag.categories << category
      marie_tag.categories << category
      session[:filter_params] = nil
      get :index, params: { category_id: category.id }
    end

    context 'after updating a tag' do
      before do
        put :update, params: { id: ada_tag.id, tag: { name: 'mathematic', languages: ['en'], categories: [category.id] } }
      end

      specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index?category_id=#{category.id}#tag_#{ada_tag.id}") }
    end

    context 'after deleting a tag' do
      before do
        delete :destroy, params: { id: ada_tag.id }
      end

      specify { expect(response).to redirect_to("/#{I18n.locale}/admin/tags/index?category_id=#{category.id}#top-anchor") }
    end
  end
end
