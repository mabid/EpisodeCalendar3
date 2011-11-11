class TicketsController < ApplicationController
  
  def create
    @ticket = Ticket.new(params[:ticket])
    if @ticket.human.blank?
      if current_user
        @ticket.is_user = true
        @ticket.from = current_user.display_name
        @ticket.email = current_user.email
      end
      if @ticket.save
        flash[:notice] = "Your support ticket was successfully sent."
        InstantMailer.deliver_support(@ticket)
      else
        flash[:ticket] = @ticket
      end
    else
      flash[:error] = "You seem to have filled out a hidden field. You must be a robot."
    end
    redirect_to info_path(:anchor => :contact)
  end
  
end