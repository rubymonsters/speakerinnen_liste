class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def new
    @category = Category.new
    build_missing_translations(@category)
  end

  def show
  end

  def index
    @categories = Category.order(:name).all
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: (I18n.t('flash.categories.created', category_name: @category.name))
    else
      render action: 'new'
    end
  end

  def edit
    build_missing_translations(@category)
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to admin_categories_path, notice: (I18n.t('flash.categories.updated', category_name: @category.name))
    else
      render action: 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: (I18n.t('flash.categories.destroyed', category_name: @category.name))
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, translations_attributes: [:id, :name, :locale])
  end
end
