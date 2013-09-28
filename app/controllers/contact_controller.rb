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
      redirect_to(root_path, :notice => "Yay! Your message was sent.")
    else
      flash.now.alert = "Please fill out all the fields so that the speaker can have all the details she needs."
      render :new
    end
  end

end
