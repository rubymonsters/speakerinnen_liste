class ContactController < ApplicationController
	
	def new 
		@message = Message.new
	end

	def create
		@message = Message.new(params[:message])

		if @message.valid?
			NotificationsMailer.new_message(@message).deliver
			redirect to(root_path, :notice => "Yay! Your message was sent.")
		else
			flash.now.alert = "Please fill out all the fields so that the speaker can have all the details she needs."
			render :new
		end
	end

end
