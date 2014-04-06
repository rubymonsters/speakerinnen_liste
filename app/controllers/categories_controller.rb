class CategoriesController < ApplicationController
  include CategoriesHelper

  def new
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
  end

  def index
    @categories = Category.all
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to category_path(@category)
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
      redirect_to category_path(@category)
    else
      render action: "edit"
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to category_url, notice: (I18n.t("flash.profiles.destroyed"))
  end
end
