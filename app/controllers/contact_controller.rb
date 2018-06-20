# frozen_string_literal: true

class ContactController < ApplicationController
  before_action :reject_spam_bots, only: [:create]

  def new
    @profile = Profile.friendly.find(params[:id]) if params[:id]
    @message = Message.new
  end

  def create
    @profile = Profile.friendly.find(params[:id]) if params[:id]
    @message = Message.new(message_params)

    if @message.valid?
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

  private

  def message_params
    params.require(:message).permit(:name, :email, :subject, :body, HONEYPOT_EMAIL_ATTR_NAME)
  end

  def reject_spam_bots
    if params[:message][:email].present? && params[:message][:email] != params[:message][HONEYPOT_EMAIL_ATTR_NAME]
      render text: 'ok'
    else
      params[:message][:email] = params[:message][HONEYPOT_EMAIL_ATTR_NAME]
    end
  end
end
