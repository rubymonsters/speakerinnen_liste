class Admin::BlockedEmailsController < Admin::BaseController
  def index
    @blocked_emails = BlockedEmail.order(created_at: :desc)
  end

  def show
    @blocked_email = BlockedEmail.find(params[:id])
  end

  def send_email
    blocked_email = BlockedEmail.find(params[:id])

    begin
      NotificationsMailer.copy_to_sender(blocked_email, blocked_email.contacted_profile_email).deliver_now
      NotificationsMailer.contact_message(blocked_email, blocked_email.contacted_profile_email).deliver_now
      blocked_email.update(sent_at: Time.current)
      redirect_to admin_blocked_email_path(blocked_email), notice: I18n.t('contact.form.notice')
    rescue => e
      redirect_to admin_blocked_email_path(blocked_email), alert: I18n.t('contact.form.error', error: e.message)
    end
  end
end
