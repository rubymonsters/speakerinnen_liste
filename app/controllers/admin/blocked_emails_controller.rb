class Admin::BlockedEmailsController < Admin::BaseController
  def index
    @blocked_emails = BlockedEmail.order(created_at: :desc)
  end

  def show
    @blocked_email = BlockedEmail.find(params[:id])
  end
end
