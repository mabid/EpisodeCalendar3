class TicketsController < ApplicationController
  
  def create
    @ticket = Ticket.new(params[:ticket])
    if @ticket.human == "13"
      if current_user
        @ticket.is_user = true
        @ticket.from = current_user.display_name
        @ticket.email = current_user.email
      end
      if @ticket.save
        flash[:notice] = "Your support ticket was successfully sent."
        SupportMailer.delay.support(@ticket)
      else
        flash[:error] = ""
        @ticket.errors.full_messages.each do |msg|
          flash[:error] += "<li>#{msg}</li>"
        end
      end
    else
      flash[:error] = "You seem to have filled out the number field wrong. You must be a robot."
    end
    redirect_to faqs_path(:anchor => :contact)
  end
  
end