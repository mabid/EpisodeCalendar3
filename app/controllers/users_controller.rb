class UsersController < ApplicationController

	require "icalendar"
	before_filter :authenticate_user!, :only => [:set_format, :destroy, :update]
	
	def index
	  @letter = params[:letter].blank? ? "a" : params[:letter]
	  @users = User.find_by_letter(@letter) #.sort_by{ |u| u.display_name }
	  @alphabet = "a".."z"
	  @total = User.all.size
  end
  
  def show
    @user = User.find(params[:id])
    @most_seen_shows = @user.followings.joins(:show).select("followings.*, marked_episodes_count * shows.runtime AS spent_watching").order("spent_watching desc").limit(6)
    @recent_shows = @user.followings.order("created_at desc").joins(:show).limit(6)
    @recent_episodes = SeenEpisode.where(["user_id = ?", @user.id]).order("created_at desc").limit(@recent_shows.size * 2).joins([:episode, :season])
    @followings = @user.followings.joins(:show).order("shows.name asc")
  end
  
	def ical
    user = User.find_by_email(params[:id])
    
    if user
      cal = Icalendar::Calendar.new
      cal.custom_property("X-WR-CALNAME","EpisodeCalendar.com")
  		start_day = Time.now.in_time_zone(user.time_zone).beginning_of_month.beginning_of_week - 1.month

      current_user_shows = Following.current.where("user_id = ?", user.id)
      shows = Show.find_all_by_id(current_user_shows.collect(&:show_id))
      shows.each do |show|
        show.episodes.find_all{|ep| !ep.air_date.nil? && ep.air_date >= start_day }.each do |episode|
          event = Icalendar::Event.new
          event.klass = "PUBLIC"
          event.summary = "#{show.name} - #{episode.format(user.episode_format)}"
          event.description = user.hide_overview_in_rss ? "" : episode.overview
                  
          air_date = episode.air_date.utc #Standard time; 00:00
          air_date += user.day_offset.days
          air_date += -(Time.now.in_time_zone(user.time_zone).utc_offset / 60 / 60).hours
          
          runtime = show.runtime.blank? ? 60 : show.runtime
          
          event.dtstart = air_date.strftime("%Y%m%dT%H0000Z")
          event.dtend = (air_date + runtime.minutes).strftime("%Y%m%dT%H0000Z")
          cal.add_event(event)
        end
      end
      
      headers["Content-Type"] = "text/calendar; charset=UTF-8"
      render :layout => false, :text => cal.to_ical
    else
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
    end
  end
  
	def rss
    @user = User.find_by_email(params[:id])
    
    if @user
      start_time = Time.now.in_time_zone(@user.time_zone).beginning_of_month.beginning_of_week - 1.month
  		start_day = DateTime.parse(start_time.to_s)
  		end_day = Time.now.in_time_zone(@user.time_zone)
  		
      episodes = []
      current_user_shows = Following.current.where("user_id = ?", @user.id)
      shows = Show.find_all_by_id(current_user_shows.collect(&:show_id))
      shows.each do |show|
        show.episodes.find_all{|ep| !ep.air_date.nil? && ep.air_date >= start_day }.each do |episode|
          episodes << episode
        end
      end
      
  		@rss_items = []
  		start_day.upto(end_day) do |date|
    	  rss_episodes = []
    	  show_banners = []
        corrected_date = date + @user.day_offset.days
  		  episodes.find_all{ |ep| ep.air_date.to_s(:air_date) == corrected_date.to_s(:air_date) }.each do |episode|
  		      rss_episodes << episode
  		      show_banners[episode.id] = episode.show.banner(:small)
  	    end
  	    if rss_episodes.any?
  	      @rss_items << [corrected_date, rss_episodes, show_banners]
        end
  	  end
      
      render :layout => false
    else
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your account was successfully updated."
    else
      flash[:error] = "Your changes could not be saved. Please try again or contact the support."
    end
    redirect_to(edit_user_registration_path(:anchor => params[:tab]))
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(root_path)
  end
  
  def set_format
  	@user = current_user
  	@user.show_format = params[:show_format]
  	@user.episode_format = params[:episode_format]
		if @user.save
      flash[:notice] = "Your account was successfully updated."
    else
      flash[:error] = "Your changes could not be saved. Please try again or contact the support."
    end
    redirect_to(edit_user_registration_path(:anchor => 1))
  end
  
  def settings
    redirect_to(edit_user_registration_path(:anchor => 1))
  end
  
  def render_progress
    @episodes_count = 0
    @seen = 0
    @time_wasted = 0
    @user = User.find(params[:user_id])
    
    #@marked_count = Rails.cache.fetch([@user.id, "marked_episodes_count"]) do
      @marked_count = Following.where(:user_id => @user.id).sum("marked_episodes_count")
    #end
    Following.where(:user_id => @user.id).each do |following|
      show = following.cached_show
      @time_wasted += show.runtime * following.marked_episodes_count unless show.runtime.blank?
    end
    @user.shows.each do |show|
      @episodes_count += show.episodes.select{ |e| !e.air_date.blank? && e.air_date < $TODAY }.size
    end

    @episodes_count -= @user.followings.sum(:hidden_episodes_count)
    
    return if @episodes_count == 0
    
    @seen = ((@marked_count.to_f / @episodes_count.to_f) * 100).floor
    
    respond_to do |format|
      format.js
    end
  end

end