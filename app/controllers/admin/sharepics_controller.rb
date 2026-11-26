# frozen_string_literal: true

class Admin::SharepicsController < Admin::BaseController
  before_action :set_sharepic, only: %i[edit update destroy]

  def index
    @sharepics = Sharepic.ordered.with_attached_image
  end

  def new
    @sharepic = Sharepic.new
  end

  def create
    @sharepic = Sharepic.new(sharepic_params)
    if @sharepic.save
      redirect_to admin_sharepics_path, notice: t('flash.sharepics.created', title: @sharepic.title)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @sharepic.update(sharepic_params)
      redirect_to admin_sharepics_path, notice: t('flash.sharepics.updated', title: @sharepic.title)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sharepic.destroy
    redirect_to admin_sharepics_path, notice: t('flash.sharepics.destroyed', title: @sharepic.title)
  end

  private

  def set_sharepic
    @sharepic = Sharepic.find(params[:id])
  end

  def sharepic_params
    params.require(:sharepic).permit(:title, :description, :position, :published, :image)
  end
end
