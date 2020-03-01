# frozen_string_literal: true

module SearchHelper
  def result_from_filter?
    params[:filter_countries].present? || params[:filter_cities].present? || params[:filter_lang].present?
  end
end
