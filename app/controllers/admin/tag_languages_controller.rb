class Admin::TagLanguagesController < Admin::BaseController
  before_action :set_tag_language, only: [:show, :edit, :update, :destroy]

  def new
  end

  def show
  end

  def index
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def tag_languages
  end

  private

  def set_tag_language
    @tag_language = TagLanguage.find(params[:tag_id])
  end

  def tag_language_params
    require(:tag_language).permit(:tag_id, :language)
  end
end
