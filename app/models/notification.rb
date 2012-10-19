class Notification < ActiveRecord::Base

	def self.daily
    user_ids = Following.select("DISTINCT user_id").collect(&:user_id)
	  User.where("id IN (?) AND daily_notification = ?", user_ids, true).each do |user|
      deliver_daily_email_for_user(user)
    end
  end
  
  def self.deliver_daily_email_for_user(user)
    episodes_to_mail = []
    today = Time.now - user.day_offset.day
    
    followings = user.followings.reject{ |s| s.send_reminder != true }
    shows = Show.where("id IN (?)", followings.collect(&:show_id)).order("name asc")
    shows.each do |show|
      episodes = Episode.where("show_id = ? AND air_date >= ?", show.id, today - 1.day)
  	  episodes.each do |episode|
  	    if episode.air_date.to_s(:air_date) == today.to_s(:air_date)
          episode_hash = {
            show_name: episode.show.name,
            format: episode.format(user.episode_format),
            name: episode.name,
            date: episode.air_date.to_s(:air_date),
            banner: episode.show.banner.blank? ? "" : HOST + episode.show.banner(:small)
          }
          episodes_to_mail << episode_hash
        end
      end
    end

    if episodes_to_mail.any?
      Mailer.delay.daily_email(user.id, episodes_to_mail)
    end
  end
    
	def self.weekly
	  user_ids = Following.select("DISTINCT user_id").collect(&:user_id)
    User.where("id IN (?) AND weekly_notification = ?", user_ids, true).each do |user|
      deliver_weekly_email_for_user(user)
    end
  end
  
  def self.deliver_weekly_email_for_user(user)
    puts "Weekly emails for user: #{user.name}" 
    episodes_to_mail = []
    episodes_array = []
    today = Time.now - user.day_offset.day

    beginning_of_week = today.end_of_week
    end_of_week = today.end_of_week + 1.week
    if (user.sun_to_sat)
      beginning_of_week -= 1.day
      end_of_week -= 1.day
    end
    beginning_of_week -= user.day_offset.day
    end_of_week -= user.day_offset.day

    followings = user.followings.reject{ |s| s.send_reminder != true }
    shows = Show.where("id IN (?)", followings.collect(&:show_id)).order("name asc")
    shows.each do |show|
      episodes = Episode.where("show_id = ? AND air_date BETWEEN ? AND ?", show.id, beginning_of_week, end_of_week)
      episodes.each do |episode|
        episode.air_date += user.day_offset.days
        if user.only_premiere_notification?
          episodes_to_mail << episode if episode.number == 1
        else
  	      episodes_to_mail << episode
	      end
		  end
    end

	  episodes_to_mail.each do |episode|
      episode_hash = {
        show_name: episode.show.name,
        format: episode.format(user.episode_format),
        name: episode.name,
        date: episode.air_date.to_s(:air_date),
        banner: episode.show.banner.blank? ? "" : HOST + episode.show.banner(:small)
      }
      episodes_array << episode_hash
    end

    #episodes_to_mail.each do |episode|
      #puts "#{episode.show.name}: #{episode.season_number}x#{episode.number}"
    #end
    
    if episodes_array.any?
      Mailer.delay.weekly_email(user.id, episodes_array.sort!{ |a,b| a[:date] <=> b[:date] })
    end
  end
	
end