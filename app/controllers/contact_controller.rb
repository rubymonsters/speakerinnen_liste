# frozen_string_literal: true

class ContactController < ApplicationController
  invisible_captcha only: [:create] , on_spam: :spam_callback_method

  def new
    @profile = Profile.friendly.find(params[:id]) if params[:id]
    @message = Message.new
  end

  def create
    @profile = Profile.friendly.find(params[:id]) if params[:id]

    # this controller is also used when someone contacts the speakerinnen team
    # in that case we have no profile
    if @profile && ( @profile.inactive? || @profile.published == false )
      redirect_to profiles_url, notice: I18n.t('flash.profiles.show_no_permission')
    else
      @message = Message.new(message_params)
      @spam_emails = ENV['FISHY_EMAILS'].present? ? ENV.fetch('FISHY_EMAILS').split(',') : ''

      if @message.valid? && @spam_emails.exclude?(@message.email)
        NotificationsMailer.new_message(@message, @profile && @profile.email).deliver
        if @profile.present?
          redirect_to(profile_path(@profile), notice: t(:notice, scope: 'contact.form'))
        else
          redirect_to(root_path, notice: t(:notice, scope: 'contact.form'))
        end
      else
        flash.now.alert = if @profile.present?
                            t(:error, scope: 'contact.form')
                          else
                            t(:error_email_for_us, scope: 'contact.form')
                          end
        render :new
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:name, :email, :subject, :body)
  end

  def spam_callback_method
    redirect_to root_path
  end

end
