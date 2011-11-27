class MailBalancersController < ApplicationController
  # GET /mail_balancers
  # GET /mail_balancers.xml
  def index
    @mail_balancers = MailBalancer.find(:all, :order => "date desc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mail_balancers }
    end
  end

  # GET /mail_balancers/1
  # GET /mail_balancers/1.xml
  def show
    @mail_balancer = MailBalancer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mail_balancer }
    end
  end

  # GET /mail_balancers/1/edit
  def edit
    @mail_balancer = MailBalancer.find(params[:id])
  end

  # PUT /mail_balancers/1
  # PUT /mail_balancers/1.xml
  def update
    @mail_balancer = MailBalancer.find(params[:id])

    respond_to do |format|
      if @mail_balancer.update_attributes(params[:mail_balancer])
        format.html { redirect_to(@mail_balancer, :notice => t('mail_balancers.update.flash')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mail_balancer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_balancers/1
  # DELETE /mail_balancers/1.xml
  def destroy
    @mail_balancer = MailBalancer.find(params[:id])
    @mail_balancer.destroy

    respond_to do |format|
      format.html { redirect_to(mail_balancers_url) }
      format.xml  { head :ok }
    end
  end
end