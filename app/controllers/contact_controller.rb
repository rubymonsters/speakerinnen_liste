class ContactController < ApplicationController
  before_filter :reject_spam_bots, only: [:create]

  def new
    @message = Message.new
  end

  def create
    if params[:id]
      @profile = Profile.find(params[:id])
    end

    @message = Message.new(message_params)

    if @message.valid?
      NotificationsMailer.new_message(@message, @profile && @profile.email).deliver
      redirect_to(root_path, notice: t(:notice, scope: 'contact.form'))
    else
      flash.now.alert = t(:error, scope: 'contact.form')
      render :new
    end
  end

  private

    def message_params
      params.require(:message).permit(:name, :email, :subject, :body, HONEYPOT_EMAIL_ATTR_NAME)
    end

    def reject_spam_bots
      if params[:message][:email].present?
        render text: 'ok'
      else
        params[:message][:email] = params[:message][HONEYPOT_EMAIL_ATTR_NAME]
      end

    end
end
