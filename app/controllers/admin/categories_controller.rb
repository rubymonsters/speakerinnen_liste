class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: %i[show edit update destroy]

  def new
    @category = Category.new
    @category.build_missing_translations
  end

  def show; end

  def index
    @categories = Category.sorted_categories
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: I18n.t('flash.categories.created', category_name: @category.name)
    else
      render action: 'new'
    end
  end

  def edit
    @category.build_missing_translations
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: I18n.t('flash.categories.updated', category_name: @category.name)
    else
      render action: 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: I18n.t('flash.categories.destroyed', category_name: @category.name)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :name_en, :name_de, :position)
  end
end
