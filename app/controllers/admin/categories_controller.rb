class Admin::CategoriesController < Admin::BaseController
  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
  end

  def index
    @categories = Category.order(:name).all
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to admin_categories_path
    else
      render action: "new"
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to admin_categories_path
    else
      render action: "edit"
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path, notice: ("You deleted '#{@category.name}'.")
  end
end
