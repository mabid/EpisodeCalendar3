class InstantMailer < ActionMailer::Base
  
  layout "email"  

  def support(ticket)
    @recipients  = "support@episodecalendar.com"
    @from        = ticket.email
    @subject     = "[#{ticket.category}] #{ticket.subject}"
    @sent_on     = Time.now
    @body[:ticket] = ticket
    content_type "text/html"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "EpisodeCalendar"
      @subject     = "EpisodeCalendar.com - "
      @sent_on     = Time.now
      @body[:user] = user
      content_type "text/html"
    end
    
end