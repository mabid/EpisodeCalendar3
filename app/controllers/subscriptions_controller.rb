class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def new

  end

  def create
    @subscription = Subscription.new(:user_id => params[:user_id], :plan_id => params[:plan_id])
    @plan = Plan.find_by_id(params[:plan_id])
    response = credit_card_payment(params[:credit_card])
    if response.success?
      @subscription.token = response.token
      @subscription.save
    else
      @subscription.destroy
      flash[:error] = response.message
      redirect_to new_subscription_path(:plan_id => @plan.id)
    end
  end

  def checkout
    setup_response = GATEWAY.setup_authorization(MONEY_IN_CENTS,
       :ip                => request.remote_ip,
       :return_url        => url_for(process_checkout_path),
       :cancel_return_url => url_for(new_subscription_path),
       :description => "DESCRIPTION_TEXT"
    )
    redirect_to GATEWAY.redirect_url_for(setup_response.token)
  end

  def return_checkout
    token = params[:token]
    authorize_response = gateway.authorize(MONEY_IN_CENTS,
     :ip       => request.remote_ip,
     :payer_id => params[:PayerID],
     :token    => params[:token]
    )

    if authorize_response.success?
      @plan = Plan.find(params[:plan_id])
      profile_response = GATEWAY.create_profile(params[:token],
        :description => 'DESCRIPTION_TEXT',
        :start_date => Date.today,
        :period => 'Month',
        :frequency => @plan.duration || 1,
        :amount => @plan.price || 0,
        :auto_bill_outstanding => true)

      if profile_response.success?
        GATEWAY.capture(money, authorize_response.authorization)

        @subscription = Subscription.new(:user_id => @current_user.id, :plan_id => params[:plan_id])
        @subscription.token = token
        @subscription.info = params[:profile_id]
        @subscription.save
      else
        GATEWAY.void(authorize_response.authorization)
      end
    end
  end

  private

  def credit_card_payment(credit_card)
    credit_card[:year] = params[:card_expires_on][:"(1i)"].to_i
    credit_card[:month] = params[:card_expires_on][:"(2i)"].to_i
    h = {:credit_card => credit_card}
    credit_card = ActiveMerchant::Billing::CreditCard.new(h[:credit_card])
    GATEWAY.create_profile( nil, :credit_card => credit_card,
       :description => "DESCRIPTION_TEXT",
       :start_date => Date.today,
       :period => 'Month',
       :frequency => @plan.duration || 1,
       :amount =>  @plan.price || 0,
       :initial_amount => @plan.price,
       :auto_bill_outstanding => true
    )
  end

end
