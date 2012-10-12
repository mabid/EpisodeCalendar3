class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper :all # include all helpers, all the time
  #protect_from_forgery # :secret => '05ceef8ef3014ff37b2dc1310bb80784'
  
  before_filter :get_tags, :footer, :set_user_time_zone, :subdomain_view_path
  helper_method :admin?, :logged_in?

  # alias_method :devise_current_user, :current_user
  # def current_user
  #     User.find(12887)
  # end

  def logged_in?
    user_signed_in?
  end  

  def get_tags
    @tags = Show.order("followers DESC").limit(25)
  end
  
  def footer
    @recently_favorited = Following.order("created_at DESC").limit(10)
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

    def subdomain_view_path
      prepend_view_path "app/views/desktop"
      prepend_view_path "app/views/mobile"
      #prepend_view_path "app/views/mobile" if request.server_name.include?("mobile") || request.user_agent =~ /Mobile|webOS|iPad/
    end
    
end
