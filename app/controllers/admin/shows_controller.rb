class Admin::ShowsController < Admin::AdminController
  
  def edit
    @show = Show.find_by_permalink(params[:id])
    @episodes_count = Episode.find(:all, :conditions => {:show_id => @show.id}).size
    @followers = Following.find(:all, :conditions => {:show_id => @show.id}).size
  end
  
  def update
    @show = Show.find_by_permalink(params[:id])
    unless params[:add_update][:type].blank?
      UpdateQueue.create(:api_id => @show.api_show_id, :update_type => params[:add_update][:type])
    end
    params[:show][:status] = @show.status if params[:show][:status].blank?
    respond_to do |format|
      if @show.update_attributes(params[:show])
        format.html { redirect_to(show_path(@show)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end