# frozen_string_literal: true

describe Admin::TagsController, type: :controller do
  include AuthHelper

  let(:admin) { FactoryBot.create(:admin) }
  let!(:ada) { FactoryBot.create(:ada, topic_list: %w[algebra algorithm computer]) }
  let!(:marie) { FactoryBot.create(:marie, topic_list: ['radioactive', 'x-ray']) }

  before(:each) do
    sign_in admin
  end

  describe 'DELETE topic' do
    context 'topic' do
      before(:each) do
        @tag = ActsAsTaggableOn::Tag.find_by_name('algorithm')
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
