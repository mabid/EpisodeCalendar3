class ShowsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :autocomplete, :public, :search, :calendar_iframe]
  
  def index
    @letter = params[:letter].blank? ? "a" : params[:letter]
    @active_shows = Show.active.find_by_letter(@letter)
    @ended_shows = Show.ended.find_by_letter(@letter)
    @top_shows = Show.find(:all, :conditions => ["id IN (?)", @active_shows.collect(&:id)], :order => "followers desc, name asc, first_aired desc", :limit => 8)
    @alphabet = "a".."z"
  end
  
  def calendar
    #flash.discard(:notice) if flash[:notice]
    year = params[:year]
    month = params[:month]

    if year.blank?
      #current month
      @start_day = DateTime.now.beginning_of_month.beginning_of_week
      @end_day = DateTime.now.end_of_month.end_of_week
      @current = DateTime.parse("#{Date.today.year}-#{Date.today.month}-01")
    else
      #year pagination
      @current = DateTime.parse("#{year}-#{month}-01")
      @start_day = @current.beginning_of_month.beginning_of_week
      @end_day = @current.end_of_month.end_of_week

      #limit the navigation to beginning of -1 year
      @prev_limit = true if DateTime.parse("#{year}-#{month}-01") <= 1.year.ago
      
      #limit the navigation to end of +1 year
      @next_limit = true if DateTime.parse("#{year}-#{month}-01") + 1.month >= 1.year.from_now
    end
    
    #get episodes
    #@show_ids = Rails.cache.fetch([current_user.id, "shows_ids", year, month]) do
      @show_ids = current_user.shows.collect(&:id)
    #end
    #@episodes = Rails.cache.fetch([current_user.id, "episodes", year, month]) do
      @episodes = Episode.all(
        :joins => :show,
        :select => "episodes.id, episodes.name, episodes.air_date, episodes.number, episodes.season_number, episodes.overview, shows.name AS show_name, shows.permalink AS show_permalink",
        :conditions => ["episodes.show_id in (?) AND air_date >= ? AND air_date <= ?", @show_ids, @start_day - 1.days, @end_day + 1.days],
        :order => "show_name asc, episodes.season_number asc, episodes.number asc"
        )
    #end
    
    @seen_episodes = SeenEpisode.find(:all, :conditions => ["user_id = ? AND episode_id IN (?)", current_user.id, @episodes.collect(&:id)]).map(&:episode_id)
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @episodes }
    end
  end
  
  def public
    if params[:year].nil?
      #current month
      @start_day = DateTime.now.beginning_of_month.beginning_of_week
      @end_day = DateTime.now.end_of_month.end_of_week
      @current = DateTime.parse("#{Date.today.year}-#{Date.today.month}-01")
    else
      #year pagination
      year = params[:year]
      month = params[:month]
      @current = DateTime.parse("#{year}-#{month}-01")
      #limit the navigation to -1 year
      if year.to_i <= 1.year.ago.beginning_of_year.year && month.to_i <= 1.year.ago.beginning_of_year.month
        year = 1.year.ago.beginning_of_year.year
        month = 1.year.ago.beginning_of_year.month
        @current = DateTime.parse("#{year}-#{month}-01")
        @prev_limit = true
      end
      #limit the navigation to +1 year
      if year.to_i >= 1.year.from_now.end_of_year.year && month.to_i >= 1.year.from_now.end_of_year.month
        year = 1.year.from_now.end_of_year.year
        month = 1.year.from_now.end_of_year.month
        @current = DateTime.parse("#{year}-#{month}-01")
        @next_limit = true
      end
      @start_day = @current.beginning_of_month.beginning_of_week
      @end_day = @current.end_of_month.end_of_week
    end
    
    #get episodes
    @episodes = Episode.all(
      :joins => :show,
      :select => "episodes.id, episodes.name, episodes.air_date, episodes.number, episodes.season_number, episodes.overview, shows.name AS show_name, shows.permalink AS show_permalink",
      :conditions => ["air_date >= ? AND air_date <= ?", @start_day - 1.days, @end_day + 1.days],
      :order => "show_name asc"
      )
    @episodes.each do |episode|
      episode.real_air_date = episode.air_date.to_s(:air_date)
    end
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @episodes }
    end
  end

  def calendar_iframe
    @start_day = DateTime.now.beginning_of_month.beginning_of_week
    @end_day = DateTime.now.end_of_month.end_of_week
    @current = DateTime.parse("#{Date.today.year}-#{Date.today.month}-01")
    
    #get episodes
    @user = User.find_by_email_and_password_salt(params[:email], params[:auth_key])
    if @user
      @show_ids = @user.shows.collect(&:id)
      @episodes = Episode.all(
        :joins => :show,
        :select => "episodes.id, episodes.name, episodes.air_date, episodes.number, episodes.season_number, episodes.overview, shows.name AS show_name, shows.permalink AS show_permalink",
        :conditions => ["episodes.show_id in (?) AND air_date >= ? AND air_date <= ?", @show_ids, @start_day - 1.days, @end_day + 1.days],
        :order => "show_name asc"
        )
      
      render :layout => "iframe"
    else
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    end
  end

  def show
    @show = Show.find_by_permalink(params[:permalink])
    if @show
      @season_size = 0
      @next_air_date = @show.next_episode.air_date unless @show.next_episode.nil?
      @seasons = Season.find(:all, :conditions => ["api_show_id = ?", @show.api_show_id], :order => "number desc")
      if params[:season]
        @season = Season.find(:first, :conditions => ["api_show_id = ? AND number = ?", @show.api_show_id, params[:season]])
        @season = @seasons.first if @season.blank?
      else
        @season = @seasons.first
      end
      @seasons.each do |season|
        @season_size += 1 unless season.number == 0
      end
      
      @is_following = false
      if current_user
        @seen_episode_ids = []
        @seen_episode_ids = SeenEpisode.find_all_by_season_id_and_user_id(@season.id, current_user.id).collect(&:episode_id) if @seasons.any?
        @is_following = current_user.is_following(@show)
      end
      if @show.episodes.empty?
        @is_queued = UpdateQueue.exists?(:api_id => @show.api_show_id)
      end
    else
      redirect_to search_path(:q => params[:permalink].gsub("-", " "))
    end    
  end
  
  def top_shows
    @user_shows = current_user.user_shows
    @top_shows = Show.all(:order => "user_shows_count desc", :limit => 100)
  end
  
  def trends
    @top_shows = Show.all(:conditions => "current_trend_position IS NOT NULL", :order => "followers desc", :limit => 20)
    @top_new_followers = Show.all(:select => "*, (followers - previous_trend_position_followers) AS new_followers", :conditions => "current_trend_position IS NOT NULL", :order => "new_followers desc", :limit => 20)
    @highest_grow = Show.all(:select => "*, (followers/previous_trend_position_followers) AS grow", :conditions => "current_trend_position IS NOT NULL AND followers > 100", :order => "grow desc", :limit => 20)
  end
  
  def facebook_button
    @show = Show.find(params[:id])
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  def search
    @query = params[:q]
    unless @query.blank?
      @query.strip!
      @shows = Show.find(:all, :conditions => ['LOWER(name) LIKE ?', "%#{@query}%"], :order => "followers DESC, status DESC, name ASC")
      if @shows.size == 1
        redirect_to show_path(@shows.first)
      end
    end
  end
  
end