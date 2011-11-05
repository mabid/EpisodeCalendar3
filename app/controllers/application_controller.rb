class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper :all # include all helpers, all the time
  #protect_from_forgery # :secret => '05ceef8ef3014ff37b2dc1310bb80784'
  
  before_filter :get_tags, :footer, :set_user_time_zone
  helper_method :admin?, :logged_in?
  
  def logged_in?
    user_signed_in?
  end  

  def get_tags
    #Rails.cache.fetch("footer") do
      @tags = Show.order("followers DESC").limit(25)
    #end
  end
  
  def footer

    #Rails.cache.fetch("footer") do
      @recently_favorited = Following.select("DISTINCT(followings.show_id), followings.*").order("created_at DESC").limit(10).joins(:show)
    #end
    @system_message = Constant.where(:key => "system_message").first
  end
  
  def admin?
    current_user && current_user.admin?
  end
  
  protected
  
    def set_user_time_zone
      if current_user
        $TODAY = Time.now.in_time_zone(current_user.time_zone)
      else
        $TODAY = Time.now.in_time_zone("UTC")
      end
    end

    def admin_area
      if current_user
        if !current_user.admin
          flash[:login_error] = "You are not logged in"
          redirect_to login_path
          return false
        end
      end
    end
    
end
