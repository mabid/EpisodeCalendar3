class FollowingsController < ApplicationController
  
  before_filter :authenticate_user!
  protect_from_forgery :only => [:update, :delete, :create]
  cache_sweeper :following_sweeper
  
  def index
    @followings = []
    unless current_user.followings.nil?
      #@followings = Rails.cache.fetch([current_user.id, "followings"]) do
        @followings = Following.find(:all, :conditions => { :user_id => current_user.id }, :include => [:show], :order => "shows.name")
      #end
      @followings_active = @followings.select{ |f| f.show.status == "Continuing" }
      @followings_ended = @followings.select{ |f| f.show.status == "Ended" }
    end
  end
    
  def create
    @show = Show.find_by_permalink(params[:permalink])
    @following = Following.new(:user_id => current_user.id, :show => @show, :send_reminder => false)
    unless @show
      flash[:error] = "The show '#{params[:permalink]}' does not exist."
    else
      if Following.exists?({:user_id => @following.user_id, :show_id => @following.show.id})
        flash[:error] = "You already have '#{@show.name}' in your list."
      else
        if @following.save
          flash[:notice] = "'#{@show.name}' has been added to your list."
          if @show.episodes.empty?
            @cron = Cron.full_show_update.first
            flash[:error] = "'#{@show.name}' has no episodes. This show's episodes will be updated within #{@cron.normalized} if any exist."
            UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => @show.api_show_id, :update_type => "all_episodes")
          end
          UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => @show.api_show_id, :update_type => "banner") if @show.banners.empty?
        end
      end
    end
    redirect_to(followings_path)
  end
  
  def destroy
    @following = Following.find(params[:id])
    @following.destroy
    redirect_to(followings_path)
  end
  
  def set_reminder
    @following = Following.find(params[:id])
    @following.send_reminder = params[:mark]
  
    if @following.save
      respond_to do |format|
        format.js
      end
    end
  end
  
  def create_multiple
    params[:show_ids].each do |show_id|
      Following.create(:show_id => show_id, :user_id => current_user.id)
    end
    redirect_to(followings_path)
  end
  
  def render_progress
    @episodes_count = 0
    @seen = 0
    @unseen = 0
    @time_wasted = 0
    
    #@marked_count = Rails.cache.fetch([current_user.id, "marked_episodes_count"]) do
      @marked_count = Following.sum("marked_episodes_count", :conditions => {:user_id => current_user.id})
    #end
    Following.find(:all, :conditions => {:user_id => current_user.id}).each do |following|
      @time_wasted += following.show.runtime * following.marked_episodes_count unless following.show.runtime.blank?
    end
    current_user.shows.each do |show|
      @episodes_count += show.episodes.select{ |e| e.air_date < $TODAY }.size
    end
    
    return if @episodes_count == 0
    
    @seen = ((@marked_count.to_f / @episodes_count.to_f) * 100).round(1)
    @unseen = (((@episodes_count.to_f - @marked_count.to_f) / @episodes_count) * 100).round(1)
    
    respond_to do |format|
      format.js
    end
  end
  
end
