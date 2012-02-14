module Api
  class UsersController < ApplicationController

    def index
      render :json => {:error => "This API action is not valid"}.to_json, :status => :not_found
    end

    def show
      @user = User.find_by_id(params[:id])
    end

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