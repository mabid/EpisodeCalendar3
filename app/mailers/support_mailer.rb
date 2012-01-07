class SupportMailer < ActionMailer::Base

  default :to => "support@episodecalendar.com"
  layout "email"

  def support(ticket)
    @ticket = ticket
    subject = "[#{ticket.category}] #{ticket.subject}"
    mail(:from => ticket.email, :reply_to => ticket.email, :subject => subject)
  end

end