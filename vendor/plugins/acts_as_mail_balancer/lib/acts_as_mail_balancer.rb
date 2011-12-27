# ActsAsMailBalancer
class MailBalancerObserver

  def self.configure(configuration)
    @mails = configuration["mails"].inject([]) do |memo, mail|
      memo << {:user_name => mail[1]["user_name"], :password => mail[1]["password"]}
    end
  end
  
  # prepare the action mailer settings for the next message
  def self.delivered_email(mail)
    used_user_name = ActionMailer::Base.smtp_settings[:user_name]
    
    if used_balancer = MailBalancer.where("date = ? and username = ?", Date.today, used_user_name).first
      # increment usage counter
      used_balancer.update_attribute(:usage_count, used_balancer.usage_count+1)
    else
      # the first call for today
      @mails.each do |mail|
        count = (mail[:user_name] == used_user_name) ? 1 : 0
        MailBalancer.create(:date => Date.today, :username => mail[:user_name], :usage_count => count)
      end
    end

    # prepare the next used mail
    next_balancer = MailBalancer.where("date = ?", Date.today).order("usage_count asc").first
    settings = @mails.find{|m| m[:user_name] == next_balancer.username}
    settings.each_pair{|k,v| ActionMailer::Base.smtp_settings[k] = v} if settings
  end
end

Mailer.register_observer(MailBalancerObserver)