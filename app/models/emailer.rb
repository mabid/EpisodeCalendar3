class Emailer < ActionMailer::Base

  self.delivery_method = :activerecord
  layout "notification"
  
  def daily_alert(user, episodes_array)
    setup_email(user)
    @subject += "Your episodes today"
    @body[:episodes] = episodes_array
  end
  
  def weekly_alert(user, episodes_array)
    setup_email(user)
    @subject += "Your episodes for Week #{(Date.today + 1.week).cweek}"
    @body[:episodes] = episodes_array
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