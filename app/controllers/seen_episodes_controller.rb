class SeenEpisodesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    corrected_date = $TODAY - current_user.day_offset.days
    followings = Following.find(:all,
    :select => "followings.*, shows.name, (SELECT count(episodes.id) FROM episodes WHERE episodes.show_id = followings.show_id AND episodes.air_date <= '#{corrected_date}') as available_episodes_count",
    :conditions => ["user_id = ? AND watch_later = ?", current_user.id, false],
    :joins => "INNER JOIN shows ON shows.id = followings.show_id",
    :order => "name asc")
    @shows = followings.select{ |f| f.available_episodes_count.to_i != (f.marked_episodes_count.to_i + f.hidden_episodes_count) }
  end
  
  def unwatched_episodes
    @show = Show.find_by_id(params[:show_id])
    seasons = Season.find_all_by_api_show_id(@show.api_show_id)
    watched_episodes = SeenEpisode.where("user_id = ? AND season_id IN (?)", current_user.id, seasons.collect(&:id))
    hidden_episodes = HiddenEpisode.where("user_id = ? AND season_id IN (?)", current_user.id, seasons.collect(&:id))
    excluded_episodes = watched_episodes.collect(&:episode_id) | hidden_episodes.collect(&:episode_id) #merge arrays
    corrected_date = ($TODAY - current_user.day_offset.days).end_of_day
    @episodes = Episode.where("show_id = ? AND air_date <= ?", @show.id, corrected_date).order("season_number asc")
    @episodes = @episodes.where("id NOT IN (?)", excluded_episodes) if excluded_episodes.any?
  end
  
  def mark_episode
    @episode = Episode.find(params[:episode_id])
    @show = @episode.show
    
    @mark_as_seen = params[:mark].to_i
    @following = Following.find_by_user_id_and_show_id(current_user.id, @show.id)
    
    if @mark_as_seen == 1
      episode = SeenEpisode.exists?(:user_id => current_user.id, :episode_id => @episode.id)
      if !episode
        SeenEpisode.create(:user_id => current_user.id, :season_id => params[:season_id], :episode_id => @episode.id)
        Following.increment_counter(:marked_episodes_count, @following.id)
      end
    else
      episode = SeenEpisode.find_by_user_id_and_episode_id(current_user.id, @episode.id)
      if episode
        episode.destroy
        Following.decrement_counter(:marked_episodes_count, @following.id)
      end
    end
    
    respond_to do |format|
      format.html { redirect_to show_path(@show) }
      format.js
    end
  end 
  
  def mark_season
    @season_id = params[:season_id]
    @show_id = params[:show_id]
    @show = Show.where(@show_id)
    marked_count = 0

    episodes = Episode.where("show_id = ? AND season_id = ? AND air_date < ?", @show_id, @season_id, $TODAY)
    episodes.each do |episode|
      record = SeenEpisode.exists?(:user_id => current_user.id, :episode_id => episode.id)
      if !record
        SeenEpisode.create(:user_id => current_user.id, :season_id => @season_id, :episode_id => episode.id)
        marked_count += 1
      end
    end
    
    @following = Following.find_by_user_id_and_show_id(current_user.id, @show_id)
    
    if @following
      new_count = @following.marked_episodes_count + marked_count
      @following.update_attributes(:marked_episodes_count => new_count)
    end
    
    respond_to do |format|
      format.html { redirect_to show_path(@show) }
      format.js
    end
  end

  def unmark_season
    @season_id = params[:season_id]
    @show_id = params[:show_id]
    @show = Show.where(@show_id)
    marked_count = 0

    episodes = Episode.where("show_id = ? AND season_id = ?", @show_id, @season_id)
    episodes.each do |episode|
      episode = SeenEpisode.find_by_user_id_and_episode_id(current_user.id, episode.id)
      if episode
        episode.destroy
        marked_count += 1
      end
    end

    @following = Following.find_by_user_id_and_show_id(current_user.id, @show_id)
    
    if @following
      new_count = @following.marked_episodes_count - marked_count    
      @following.update_attributes(:marked_episodes_count => new_count)
    end

    respond_to do |format|
      format.html { redirect_to show_path(@show) }
      format.js
    end
  end
  
  def mark_show
    @show_id = params[:show_id]
    @show = Show.where(@show_id)
    
    episodes_count = 0
    
    seen_episodes_ids = SeenEpisode.where("user_id = ? AND season_id = ?", current_user.id, @season_id).map(&:episode_id)
    episodes = Episode.where("show_id = ? AND air_date < ?", @show_id, $TODAY)
    
    episodes.each do |episode|
      unless seen_episodes_ids.include?(episode.id)
        SeenEpisode.find_or_create_by_user_id_and_episode_id(:user_id => current_user.id, :season_id => episode.season_id, :episode_id => episode.id)
      end
      episodes_count += 1
    end

    @following = Following.find_by_user_id_and_show_id(current_user.id, @show_id)
    @following.update_attributes(:marked_episodes_count => episodes_count) if @following

    respond_to do |format|
      format.html { redirect_to show_path(@show) }
      format.js
    end
  end
  
end
