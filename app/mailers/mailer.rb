class Mailer < ActionMailer::Base

  default :from => "account@episodecalendar.com"
  layout "notification"
 
  def daily_email(user_id, episodes_array)
    subject = "EpisodeCalendar.com - Your episodes for today"
    @user = User.find(user_id)
    @episodes = episodes_array
    mail(:to => @user.email, :reply_to => @user.email, :subject => subject)
  end
 
  def weekly_email(user_id, episodes_array)
    subject = "EpisodeCalendar.com - Your episodes for Week #{(Date.today + 1.week).cweek}"
    @user = User.find(user_id)
    @episodes = episodes_array
    mail(:to => @user.email, :reply_to => @user.email, :subject => subject)
  end

  def successful_subscription(subscription)
    @subscription = subscription
    subject = "Successful Subscription"
    mail(:from => "support@episodecalendar.com", :to => subscription.user.email, :reply_to => subscription.user.email, :subject => subject)
  end

  def remove_subscription(subscription)
    @subscription = subscription
    subject = "Subscription Removed"
    mail(:from => "support@episodecalendar.com", :to => subscription.user.email, :reply_to => subscription.user.email, :subject => subject)
  end

end