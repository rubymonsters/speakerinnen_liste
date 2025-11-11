class Admin::OffensiveTermsController < Admin::BaseController
  before_action :set_offensive_term, only: [:edit, :update, :destroy]

  def index
    @offensive_terms = OffensiveTerm.order(:word)
  end

  def new
    @offensive_term = OffensiveTerm.new
  end

  def create
    @offensive_term = OffensiveTerm.new(offensive_term_params)
    if @offensive_term.save
      redirect_to admin_offensive_terms_path, notice: 'Offensive term added.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @offensive_term.update(offensive_term_params)
      redirect_to admin_offensive_terms_path, notice: 'Offensive term updated.'
    else
      render :edit
    end
  end

  def destroy
    @offensive_term.destroy
    redirect_to admin_offensive_terms_path, notice: 'Offensive term deleted.'
  end

  private

  def set_offensive_term
    @offensive_term = OffensiveTerm.find(params[:id])
  end

  def offensive_term_params
    params.require(:offensive_term).permit(:word)
  end
end
