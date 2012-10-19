class HiddenEpisodesController < ApplicationController

before_filter :authenticate_user!
  
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
    @show = Show.where(@show_id)
    hidden_count = 0
    seen_count = 0

    episodes = Episode.where("show_id = ? AND season_id = ? AND air_date < ?", @show_id, @season_id, $TODAY)
    episodes.each do |episode|
      record = HiddenEpisode.exists?(:user_id => current_user.id, :episode_id => episode.id)
      if !record
        HiddenEpisode.create(:user_id => current_user.id, :season_id => @season_id, :episode_id => episode.id)
        hidden_count += 1
      end
      seen_episode = SeenEpisode.find_by_user_id_and_episode_id(current_user.id, episode.id)
      if seen_episode
        seen_episode.destroy
        seen_count += 1
      end
    end
    
    @following = Following.find_by_user_id_and_show_id(current_user.id, @show_id)
    
    if @following
      new_hidden_count = @following.hidden_episodes_count + hidden_count
      new_seen_count = @following.marked_episodes_count - seen_count
      @following.update_attributes(:marked_episodes_count => new_seen_count, :hidden_episodes_count => new_hidden_count)
    end
    
    respond_to do |format|
      format.html { redirect_to show_path(@show) }
      format.js
    end
  end

  def unhide_season
    @season_id = params[:season_id]
    @show_id = params[:show_id]
    @show = Show.where(@show_id)
    hidden_count = 0

    episodes = Episode.where("show_id = ? AND season_id = ?", @show_id, @season_id)
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