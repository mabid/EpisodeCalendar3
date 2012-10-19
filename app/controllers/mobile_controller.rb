class MobileController < ApplicationController
  
  def authenticate
    @email = params[:email]
    @password = params[:password]
    
    @user = User.find_by_email(@email)
    if @user
      @valid_user = @user.valid_password?(@password)
    else
      @valid_user = false
    end
    
    if @valid_user
      constant = Constant.where("`key` = ? AND `value` = ?", "mobile_login", params[:platform]).first
      constant.update_attributes(:additional_data => constant.additional_data.to_i + 1)
      @auth_key = @user.password_salt
    end
    
    render :layout => false
  end  
  
	def rss
    @email = params[:email]
    @auth_key = params[:auth_key]
    @user = User.find_by_email_and_password_salt(@email, @auth_key)
    
    if @user
      @auth_key = @user.password_salt
      @time_zone_offset = ActiveSupport::TimeZone[@user.time_zone].utc_offset/60/60
      @seen_episode_ids = SeenEpisode.find_all_by_user_id(@user.id).collect(&:episode_id).sort()
  
  		start_day = DateTime.now.beginning_of_month.beginning_of_week - 1.month
  		end_day = DateTime.now + 1.day
  		
      current_user_shows = Following.current.where("user_id = ?", @user.id)
      show_ids = Show.find_all_by_id(current_user_shows.collect(&:show_id))
      episodes = Episode.where("episodes.show_id IN (?) AND air_date IS NOT NULL AND air_date >= ? AND air_date <= ?", show_ids, start_day, end_day).joins(:show).order("episodes.air_date desc, shows.name, episodes.number asc")
  		@rss_items = episodes.group_by { |ep| [ep.air_date] }
    end #if user
    
    render :layout => false
  end
  
	def check_off
    @episode_id = params[:episode_id]
    @value = params[:value]
    @email = params[:email]
    @auth_key = params[:auth_key]
    @user = User.find_by_email_and_password_salt(@email, @auth_key)
    
    if @user
      #begin
      @episode = Episode.find(@episode_id)
      @show = @episode.show
      
      mark_as_seen = @value
      @following = Following.find_by_user_id_and_show_id(@user.id, @show.id)
      
      if mark_as_seen.to_i == 1
        episode = SeenEpisode.exists?(:user_id => @user.id, :episode_id => @episode.id)
        if !episode
          SeenEpisode.create(:user_id => @user.id, :season_id => @episode.season_id, :episode_id => @episode.id)
          Following.increment_counter(:marked_episodes_count, @following.id)
        end
      else
        episode = SeenEpisode.find_by_user_id_and_episode_id(@user.id, @episode.id)
        if episode
          episode.destroy
          Following.decrement_counter(:marked_episodes_count, @following.id)
        end
      end

      #rescue
      #end
      
    end
    
    render :layout => false
  end
  
end