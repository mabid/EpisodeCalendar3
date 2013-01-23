require "#{Whenever.path}/config/environment.rb"

set :path, "/var/www/episodecalendar.com/production/current"

Cron.all.each do |cron|
  next if cron.command.blank?
  if cron.at.blank?
    
    eval <<-EVAL
      every cron.run_interval do
        #{cron.cmd}
      end
    EVAL
    
  else

    eval <<-EVAL
      every cron.run_interval, :at => cron.time do
        #{cron.cmd}
      end
    EVAL
    
  end
end

every 1.day do
  command "cd /var/www/episodecalendar.com/production/current && bundle exec whenever --update-crontab episodecalendar.com"
  rake "subscription:check_subscription"
end

every '0 2 10 * *' do
  rake "subscription:check_subscription"
end