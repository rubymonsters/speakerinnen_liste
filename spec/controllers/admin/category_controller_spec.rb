# frozen_string_literal: true

describe Admin::CategoriesController, type: :controller do
  include AuthHelper

  let(:admin) { create(:profile, :admin) }
  let!(:category) { FactoryBot.create(:cat_science) }

  before(:each) do
    sign_in admin
  end

  describe 'GET new' do
    before(:each) {  get :new }

    specify { expect(response).to render_template(:new) }
  end

  describe 'POST create' do
    before(:each) do
      @old_categories = Category.count
      post :create, params: { category: { name: 'Science' } }
    end

    specify { expect(response).to redirect_to("/#{I18n.locale}/admin/categories") }
    it 'adds a category' do
      expect(assigns(:category).name).to eq 'Science'
      expect(Category.count).to be @old_categories + 1
    end
  end

  describe 'GET index' do
    before(:each) do
      get :index
    end

    specify { expect(response).to render_template(:index) }
    it 'displays the category' do
      expect(assigns(:categories)).to eq([category])
    end
  end

  describe 'GET edit' do
    before(:each) do
      get :edit, params: { id: category.id }
    end

    specify { expect(response).to render_template(:edit) }
    it 'should edit the correct category' do
      expect(assigns(:category)).to eq(category)
    end

    it 'builds translation' do
      expect(assigns(:category).translations.size).to eq 2
    end
  end

  describe 'PUT update' do
    context 'rename the category' do
      before(:each) do
        put :update, params: { id: category.id, category: { name: 'Science & Technology' } }
      end

      specify { expect(response).to redirect_to("/#{I18n.locale}/admin/categories") }
      it 'changes the category name' do
        expect(assigns(:category).name).to eq 'Science & Technology'
      end
    end
  end

  describe 'DESTROY category' do
    before(:each) do
      delete :destroy, params: { id: category.id }
    end

    it 'deletes the category' do
      expect { Category.find(category.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      expect(Category.count).to be 0
    end
  end

  context 'translations' do
    before(:each) do
      category.update(name_de: 'Wissenschaft', name_en: 'Science')

      category_params = {
        name_de: 'Kunst',
        name_en: 'Art'
      }

      patch :update, params: { id: category.id, category: category_params }
    end

    it "shows the updated German translation" do
      I18n.locale = :de
      expect(assigns(:category).name).to eq 'Kunst'
    end

    it "shows the updated English translation" do
      I18n.locale = :en
      expect(assigns(:category).name).to eq 'Art'
    end
  end
end
