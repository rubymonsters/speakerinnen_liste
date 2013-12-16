class ContactController < ApplicationController
  def new 
    @message = Message.new
  end

  def create
    if params[:id]
      @profile = Profile.find(params[:id]) 
    end

    @message = Message.new(params[:message])

    if @message.valid?
      NotificationsMailer.new_message(@message, @profile && @profile.email).deliver
      redirect_to(root_path, :notice => t(:notice, scope: "contact.form"))
    else
      flash.now.alert = t(:error, scope: "contact.form") 
      render :new
    end
  end
end