include AuthHelper

describe Admin::CategoriesController, type: :controller do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }
  let!(:category) { FactoryGirl.create(:category) }

  before(:each) do
    sign_in admin
  end

  describe 'GET new' do
    before(:each) {  get :new  }

    specify { expect(response).to render_template(:new) }
    it 'builds translation' do
      expect(assigns(:category).translations.size).to eq 3
    end
  end

  describe 'POST create' do
    before(:each) do
      @old_categories = Category.count
      post :create, 'category'=>{'translations_attributes'=>{'0'=>{'locale'=>'de', 'name'=>'Wissenschaft'}, '1'=>{'locale'=>'en', 'name'=>'Science'}, '2' => {'locale'=>'pt', 'name'=>'Ciência'}}}
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
      get :edit, id: category.id
    end

    specify { expect(response).to render_template(:edit) }
    it 'should edit the correct category' do
      expect(assigns(:category)).to eq(category)
    end

    it 'builds translation' do
      expect(assigns(:category).translations.size).to eq 3
    end
  end

  describe 'PUT update' do
    context 'rename the category' do

      before(:each) do
        put :update, id: category.id, category: { name: 'Science & Technology' }
      end

      specify { expect(response).to redirect_to("/#{I18n.locale}/admin/categories") }
      it 'changes the category name' do
        expect(assigns(:category).name).to eq 'Science & Technology'
      end
    end
  end

  describe 'DESTROY category' do
    before(:each) do
      delete :destroy, id: category.id
    end

    it 'deletes the category' do
      expect { Category.find(category.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      expect(Category.count).to be 0
    end
  end

  context 'translations' do
    before(:each) do
      de_factory_translation = category.translations.find_by('locale' => 'de')
      en_translation = category.translations.create!('locale' => 'en')
      pt_translation = category.translations.create!('locale' => 'pt')

      category_params = {
        translations_attributes:
          { '0':
            {
              'locale':       'de',
              'name':         'Wissenschaft',
              'id':           de_factory_translation.id
            },
          '1':
            {
              'locale':       'en',
              'name':         'Science',
              'id':           en_translation.id
            },
          '2':
            {
              'locale':       'pt',
              'name':         'Ciência',
              'id':           pt_translation.id
            }
            }
      }
      patch :update, { id: category.id }.merge(category: category_params)
    end

    it "doesn't create extra translations" do
      expect(category.reload.translations.size).to eq(3)
    end

    it "show the correct translation when 'I18n.locale :de'" do
      I18n.locale = 'de'
      expect(assigns(:category).name).to eq 'Wissenschaft'
    end

    it "show the correct translation when 'I18n.locale :en'" do
      I18n.locale = 'en'
      expect(assigns(:category).name).to eq 'Science'
    end

    it "show the correct translation when 'I18n.locale :pt'" do
      I18n.locale = 'pt'
      expect(assigns(:category).name).to eq 'Ciência'
    end
  end
end
