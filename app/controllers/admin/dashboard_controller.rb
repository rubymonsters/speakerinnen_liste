# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  def index
    @unreviewed_count = BlockedEmail.unreviewed.count
  end
end
