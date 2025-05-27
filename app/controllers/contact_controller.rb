# frozen_string_literal: true

class ContactController < ApplicationController
  invisible_captcha only: [:create], on_spam: :spam_callback_method

  before_action :load_profile, only: [:new, :create]
  before_action :reject_inactive_profile, only: [:create]

  def new
    @message = Message.new
  end

  def create
    result = ContactForm::SubmitInteractor.call(
      params: message_params,
      profile: @profile
    )

    if result.success?
      redirect_to(
        @profile.present? ? profile_path(@profile) : root_path,
        notice: t(:notice, scope: 'contact.form')
      )
    else
      @message = result.message
      flash.now.alert = result.error
      render :new
    end
  end

  private

  def load_profile
    @profile = Profile.friendly.find(params[:id]) if params[:id].present?
  end

  def reject_inactive_profile
    return unless @profile&.inactive? || @profile&.published == false

    redirect_to profiles_url, notice: I18n.t('flash.profiles.show_no_permission')
  end
  
  def message_params
    params.require(:message).permit(:name, :email, :subject, :body)
  end
end