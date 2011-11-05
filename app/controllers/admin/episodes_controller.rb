class Admin::EpisodesController < Admin::AdminController
    
  def index
  end
  
  def edit
    @episode = Episode.find(params[:id])
  end
  
  def update
    @episode = Episode.find(params[:id])
    respond_to do |format|
      if @episode.update_attributes(params[:episode])
        format.html { redirect_to(show_path(@episode.show)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @episode = Episode.find(params[:id])
    @episode.destroy
    redirect_to(show_path(:permalink => @episode.show.permalink))
  end

end