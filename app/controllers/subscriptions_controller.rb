class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def new

  end

  def create
    @subscription = @current_user.subscription ? Subscription.find_by_user_id(params[:user_id]) : Subscription.new(:user_id => params[:user_id])
    @plan = Plan.find_by_name(params[:plan])
    response = @subscription.upgrade(@plan, params[:credit_card], params[:card_expires_on])
    if response
      Mailer.successful_subscription(@subscription)
      redirect_to "/settings"
    else
      flash[:error] = response
      redirect_to new_subscription_path(:plan => @plan.name)
    end
  end

  def destroy
    if @current_user.subscription.unsubscribed
      @current_user.plan = Plan.find_by_name("Free")
      flash[:notice] = 'You have successfully un-subscribed'
    else
      flash[:notice] = 'Could not un-subscribe. Try Again later.'
    end
    redirect_to root_url
  end

end
