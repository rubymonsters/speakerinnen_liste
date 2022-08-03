# frozen_string_literal: true

module SearchHelper
  def all_states
    t(:states).map(&:last).inject(&:merge)
  end

  def filter_params
    filter_params = {
      search: params[:search],
      filter_country: params[:filter_country],
      filter_city: params[:filter_city],
      filter_language: params[:filter_language],
      filter_state: params[:filter_state]
    }
  end
end
