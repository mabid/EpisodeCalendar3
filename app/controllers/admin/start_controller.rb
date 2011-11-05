class Admin::StartController < Admin::AdminController
    
  def index
    
    #STATISTICS
    ###########################################################
    
    @total_shows = Show.count
    @total_episodes = Episode.count
    
    @user_count = User.count
    @user_show_count = Following.count
    @avg = @user_show_count.to_f / @user_count.to_f
    
    z = 2.hours
    
    @users_last_month = User.find(:all, :conditions => ["created_at BETWEEN ? AND ?", 1.month.ago.beginning_of_month+z, 1.month.ago.end_of_month+z]).size
    @users_this_month = User.find(:all, :conditions => ["created_at BETWEEN ? AND ?", Date.today.beginning_of_month.beginning_of_day, Date.today.end_of_month.end_of_day]).size

    @users_last_week = User.find(:all, :conditions => ["created_at BETWEEN ? AND ?", 1.week.ago.beginning_of_week+z, 1.week.ago.end_of_week+z]).size
    @users_this_week = User.find(:all, :conditions => ["created_at BETWEEN ? AND ?", Date.today.beginning_of_week.beginning_of_day, Date.today.end_of_week.end_of_day]).size

    @users_yesterday = User.find(:all, :conditions => ["created_at BETWEEN ? AND ?", 1.day.ago.beginning_of_day+z, 1.day.ago.end_of_day+z]).size
    @users_today = User.find(:all, :conditions => ["created_at > ?", Date.today.beginning_of_day]).size

    @uniq_show_ids = Following.find(:all, :group => :show_id, :order => "show_id ASC")
    @uniq_shows = Show.find(:all, :conditions => ["id IN (?)", @uniq_show_ids.collect(&:show_id)], :order => "followers DESC", :limit => 25)

    @users = User.find(:all, :order => "followings_count DESC", :conditions => "followings_count > 0", :limit => 25)
    
    @active_users = User.find(:all, :conditions => ["last_sign_in_at > ?", Date.today - 30.days]).size
    @inactive_users = @user_count - @active_users
    
    @users_by_day = users_chart_series(4.weeks.ago.utc)
    
    #LOG
    ###########################################################
    @shows_updated = Log.shows_updated
    @episodes_updated = Log.episodes_updated
    @banners_updated = Log.banners_updated
    @show_trends_updated = Log.show_trends_updated
    
    #STATUS
    ###########################################################
    @queue_update = Cron.queue_update.first
    @shows_update = Cron.shows_update.first
    @episodes_update = Cron.episodes_update.first
    @banners_update = Cron.banners_update.first
    @trends_update = Cron.trends_update.first
    @send_emails = Cron.send_emails.first
  
    @next_email = Email.first

    #CONSTANTS AND CRONS
    ###########################################################
    @constants = Constant.all
    @crons = Cron.all

  end
  
  
  def users_chart_series(start_time)
    arr = User.find(:all, :conditions => {:created_at => start_time.beginning_of_day..Time.now.end_of_day}, :group => "date(created_at)", :select => "created_at, count(created_at) as total")
    (start_time.to_date..Date.today).map do |date|
      user = arr.detect { |user| user.created_at.to_date == date }
      user && user.total.to_f || 0
    end
  end
      
end