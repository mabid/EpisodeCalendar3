module Api
  class FollowingsController < ApplicationController

    def create
      respond_with User.create(params[:user])
    end

    def update
      respond_with User.update(params[:id], params[:user])
    end

    def destroy
      respond_with User.destroy(params[:id])
    end
    
  end
end