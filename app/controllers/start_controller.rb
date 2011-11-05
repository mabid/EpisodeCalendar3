class StartController < ApplicationController
  
  def index
    flash.discard(:notice) if flash[:notice]
    redirect_to calendar_path if logged_in?
  end
  
end