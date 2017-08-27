class Admin::TagLanguagesController < Admin::BaseController
  def create
    @tag_language = @tag.set_tag_language(tag_language_params)
    @tag_language.save
    redirect_to admin_categories_path, notice: ('tag language created!')
  end

private

  def tag_language_params
    params.require(:tag_language).permit(:tag_id, :language)
  end
end
