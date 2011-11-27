class HiddenEpisodesController < ApplicationController

before_filter :authenticate_user!
  
  def index
    corrected_date = $TODAY - current_user.day_offset.days
    followings = Following.find(:all,
    :select => "followings.*, shows.name, (SELECT count(episodes.id) FROM episodes WHERE episodes.show_id = followings.show_id AND episodes.air_date <= '#{corrected_date}') as available_episodes_count",
    :conditions => ["user_id = ?", current_user.id],
    :joins => "INNER JOIN shows ON shows.id = followings.show_id",
    :order => "name asc")
    @shows = followings.select{ |f| f.available_episodes_count.to_i != f.hidden_episodes_count.to_i}
  end
  
  def hidden_episodes
    show_id = params[:show_id]
    @show = Show.find_by_id(show_id)
    seasons = Season.find_all_by_api_show_id(@show.api_show_id)
    hidden_episodes = HiddenEpisode.find(:all, :conditions => ["user_id = ? AND season_id IN (?)", current_user.id, seasons.collect(&:id)])
    corrected_date = ($TODAY - current_user.day_offset.days).end_of_day
    if hidden_episodes.any?
      @episodes = Episode.find(:all, :conditions => ["show_id = ? AND id NOT IN (?) AND air_date <= ?", @show.id, hidden_episodes.collect(&:episode_id), corrected_date], :order => "season_number asc")
    else
      @episodes = Episode.find(:all, :conditions => ["show_id = ? AND id AND air_date <= ?", @show.id, corrected_date], :order => "season_number asc")
    end
  end
  
  def hide_episode
    @episode = Episode.find(params[:episode_id])
    @show = @episode.show
    
    @mark_as_hidden = params[:hide].to_i
    @following = Following.find_by_user_id_and_show_id(current_user.id, @show.id)
    
    if @mark_as_hidden == 1
      episode = HiddenEpisode.exists?(:user_id => current_user.id, :episode_id => @episode.id)
      if !episode
        seen_episode = SeenEpisode.find_by_user_id_and_episode_id(current_user.id, @episode.id)
        if seen_episode
          seen_episode.destroy
          Following.decrement_counter(:marked_episodes_count, @following.id)
        end
        SeenEpisode.delete_all(["user_id = ? AND episode_id = ?", current_user.id, @episode.id])
        HiddenEpisode.create(:user_id => current_user.id, :season_id => params[:season_id], :episode_id => @episode.id)
        Following.increment_counter(:hidden_episodes_count, @following.id)
      end
    else
      episode = HiddenEpisode.find_by_user_id_and_episode_id(current_user.id, @episode.id)
      if episode
        episode.destroy
        Following.decrement_counter(:hidden_episodes_count, @following.id)
      end
    end
    
    respond_to do |format|
      format.html { redirect_to show_path(@show) }
      format.js { render :nothing => true }
    end
  end
  
  def hide_season
    @season_id = params[:season_id]
    @show_id = params[:show_id]
    @show = Show.find(@show_id)
    hidden_count = 0

    episodes = Episode.find(:all, :conditions => ["show_id = ? AND season_id = ? AND air_date < ?", @show_id, @season_id, $TODAY])
    episodes.each do |episode|
      record = HiddenEpisode.exists?(:user_id => current_user.id, :episode_id => episode.id)
      if !record
        HiddenEpisode.create(:user_id => current_user.id, :season_id => @season_id, :episode_id => episode.id)
        hidden_count += 1
      end
    end
    
    @following = Following.find_by_user_id_and_show_id(current_user.id, @show_id)
    
    if @following
      new_count = @following.hidden_episodes_count + hidden_count
      @following.update_attributes(:hidden_episodes_count => new_count)
    end
    
    respond_to do |format|
      format.html { redirect_to show_path(@show) }
      format.js
    end
  end

  def unhide_season
    @season_id = params[:season_id]
    @show_id = params[:show_id]
    @show = Show.find(@show_id)
    hidden_count = 0

    episodes = Episode.find(:all, :conditions => ["show_id = ? AND season_id = ?", @show_id, @season_id])
    episodes.each do |episode|
      episode = HiddenEpisode.find_by_user_id_and_episode_id(current_user.id, episode.id)
      if episode
        episode.destroy
        hidden_count += 1
      end
    end
    
    @following = Following.find_by_user_id_and_show_id(current_user.id, @show_id)
    
    if @following
      new_count = @following.hidden_episodes_count - hidden_count    
      @following.update_attributes(:hidden_episodes_count => new_count)
    end

    respond_to do |format|
      format.html { redirect_to show_path(@show) }
      format.js
    end
  end
  
end