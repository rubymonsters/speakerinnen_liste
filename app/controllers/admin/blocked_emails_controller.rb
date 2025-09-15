class Admin::BlockedEmailsController < Admin::BaseController
  def index
    @blocked_emails = BlockedEmail.order(created_at: :desc)
  end

  def show
    @blocked_email = BlockedEmail.find(params[:id])
  end

  def send_email
    blocked_email = BlockedEmail.find(params[:id])
    byebug

    NotificationsMailer.copy_to_sender(blocked_email.message, blocked_email.context.profile.fullname).deliver_now
    NotificationsMailer.contact_message(blocked_email.message, blocked_email.recipient_email).deliver_now

    redirect_to admin_blocked_email_path(blocked_email), notice: "Email has been sent."
  end
end
