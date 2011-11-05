class Admin::CronsController < Admin::AdminController  
  
  def new
    @cron = Cron.new
  end
  
  def create
    @cron = Cron.new(params[:cron])
    if @cron.save
      flash[:notice] = "Successfully created cron."
      redirect_to admin_start_url(:anchor => "4")
    else
      render :action => 'new'
    end
  end
  
  def edit
    @cron = Cron.find(params[:id])
  end
  
  def update
    @cron = Cron.find(params[:id])
    if @cron.update_attributes(params[:cron])
      flash[:notice] = "Successfully updated cron."
      redirect_to admin_start_url(:anchor => "4")
    else
      render :action => 'edit'
    end
  end  
  
  def destroy
    @cron = Cron.find(params[:id])
    @cron.destroy
    redirect_to admin_start_url(:anchor => "4")
  end
  
end
