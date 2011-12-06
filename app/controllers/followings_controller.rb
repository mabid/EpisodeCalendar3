class FollowingsController < ApplicationController
  
  before_filter :authenticate_user!
  protect_from_forgery :only => [:update, :delete, :create]
  cache_sweeper :following_sweeper
  
  def index
    @followings = []
    unless current_user.followings.nil?
      #@followings = Rails.cache.fetch([current_user.id, "followings"]) do
        #@followings = Following.find(:all, :conditions => { :user_id => current_user.id }, :include => [:show], :order => "shows.name")
        @followings = Following.where(:user_id => current_user.id).joins(:show).order("shows.name")
      #end
      @followings_active = @followings.select{ |f| f.show.status == "Continuing" && f.watch_later == false }
      @followings_ended = @followings.select{ |f| f.show.status == "Ended" && f.watch_later == false }
      @followings_watch_later = @followings.select{ |f| f.watch_later == true }
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

  def set_watch_later
    @following = Following.find(params[:show_id])
    @following.update_attributes(:watch_later => params[:mark].to_i, :send_reminder => false)
    redirect_to(followings_path)
  end
  
  def create_multiple
    params[:show_ids].each do |show_id|
      Following.create(:show_id => show_id, :user_id => current_user.id)
    end
    redirect_to(followings_path)
  end
  
end
