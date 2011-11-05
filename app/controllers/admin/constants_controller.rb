class Admin::ConstantsController < Admin::AdminController  
  
  def new
    @constant = Constant.new
  end
  
  def create
    @constant = Constant.new(params[:constant])
    if @constant.save
      flash[:notice] = "Successfully created constant."
      redirect_to admin_start_url(:anchor => "4")
    else
      render :action => 'new'
    end
  end
  
  def edit
    @constant = Constant.find(params[:id])
  end
  
  def update
    @constant = Constant.find(params[:id])
    if @constant.update_attributes(params[:constant])
      flash[:notice] = "Successfully updated constant."
      redirect_to admin_start_url(:anchor => "4")
    else
      render :action => 'edit'
    end
  end  
  
  def destroy
    @constant = Constant.find(params[:id])
    @constant.destroy
    redirect_to admin_start_url(:anchor => "4")
  end
  
end
