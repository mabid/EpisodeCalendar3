class Notification < ActiveRecord::Base

	def self.daily
	  user_ids = Following.find(:all).collect(&:user_id).uniq
	  User.find(:all, :conditions => ["id IN (?) AND daily_notification = ?", user_ids, true]).each do |user|
      deliver_daily_email_for_user(user)
    end
  end
  
  def self.deliver_daily_email_for_user(user)
    episodes_to_mail = []
    today = Time.now.in_time_zone(user.time_zone) - user.day_offset.day
    
    followings = user.followings.reject{ |s| s.send_reminder != true }
    shows = Show.all(:conditions => ["id IN (?)", followings.collect(&:show_id)], :order => "name asc")
    shows.each do |show|
      episodes = Episode.all(:conditions => ["show_id = ? AND air_date >= ?", show.id, today - 1.day])
  	  episodes.each do |episode|
  	    episodes_to_mail << [episode.show.name, episode.format(user.episode_format), episode.name] if episode.air_date.to_s(:air_date) == today.to_s(:air_date)
      end
    end
    
    if episodes_to_mail.any?
      Emailer.deliver_daily_alert(user, episodes_to_mail)
    end
  end
    
	def self.weekly
	  user_ids = Following.find(:all).collect(&:user_id).uniq
	  User.find(:all, :conditions => ["id IN (?) AND weekly_notification = ?", user_ids, true]).each do |user|
      deliver_weekly_email_for_user(user)
    end
  end
  
  def self.deliver_weekly_email_for_user(user) 
    episodes_to_mail = []
    episodes_array = []
    today = Time.now.in_time_zone(user.time_zone) - user.day_offset.day

    followings = user.followings.reject{ |s| s.send_reminder != true }
    shows = Show.all(:conditions => ["id IN (?)", followings.collect(&:show_id)], :order => "name asc")
    shows.each do |show|
      episodes = Episode.all(:conditions => ["show_id = ? AND air_date > ?", show.id, today - 2.days])
      episodes.each do |episode|
    	  if episode.air_date > today.end_of_week && episode.air_date <= today.end_of_week + 1.week
          if user.only_premiere_notification?
            episodes_to_mail << episode if episode.number == 1
          else
    	      episodes_to_mail << episode
  	      end
        end
		  end
    end

	  episodes_to_mail.each do |episode|
	    episodes_array << [episode.show.name, episode.format(user.episode_format), episode.name]
    end
    
    if episodes_array.any?
      Emailer.deliver_weekly_alert(user, episodes_array)
    end
  end
	
end
