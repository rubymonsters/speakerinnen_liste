class Admin::BlockedEmailsController < Admin::BaseController
  before_action :set_blocked_email, only: %i[show send_email mark_reviewed]
  def index
    @blocked_emails = BlockedEmail.order(reviewed: :asc, created_at: :desc)
  end

  def show; end

  def send_email
    NotificationsMailer.copy_to_sender(@blocked_email, @blocked_email.contacted_profile_email).deliver_now
    NotificationsMailer.contact_message(@blocked_email, @blocked_email.contacted_profile_email).deliver_now
    @blocked_email.update(sent_at: Time.current)
    redirect_to admin_blocked_email_path(@blocked_email), notice: I18n.t('contact.form.notice')
  rescue StandardError => e
    redirect_to admin_blocked_email_path(@blocked_email), alert: I18n.t('contact.form.error', error: e.message)
  end

  def mark_reviewed
    @blocked_email.update!(reviewed: true)

    redirect_to admin_blocked_email_path(@blocked_email),
                notice: 'Die E-Mail wurde als geprüft markiert.'
  end

  private

  def set_blocked_email
    @blocked_email = BlockedEmail.find(params[:id])
  end
end
