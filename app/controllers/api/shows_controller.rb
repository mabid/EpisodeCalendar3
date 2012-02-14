module Api
  class ShowsController < ApplicationController

    def index
      if params[:name].present?
        @shows = Show.where("name LIKE ?", "%#{params[:name]}%")
      else
        render :json => {:error => "This API action is only used as a search. Add a name paramater to the URL, like so: /api/shows?name=girl"}.to_json, :status => :not_found
      end
    end

    def show
      @show = Show.find_by_id(params[:id])
    end
    
  end
end