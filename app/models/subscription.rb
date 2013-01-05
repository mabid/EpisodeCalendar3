class Subscription < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :plan

  def upgrade(plan, credit_card, card_expires_on)
    self.plan_id = plan.id
    response = credit_card_payment(plan, credit_card, card_expires_on)
    if response.success?
      self.profile_id = response.params['profile_id']
      self.status = response.params['profile_status']
      save
    else
      response.message
    end
  end

  def status
    if profile_id
      GATEWAY.status_recurring(profile_id)
    else
      false
    end
  end

  def suspend
    if profile_id
      GATEWAY.suspend_recurring(profile_id)
      self.status = "SuspendedProfile"
      save
    else
      false
    end
  end

  def reactivate
    if profile_id
      GATEWAY.reactivate_recurring(profile_id)
      self.status = "ActiveProfile"
      save
    else
      false
    end
  end

  def charge
    if profile_id
      GATEWAY.bill_outstanding_amount(profile_id)
    else
      false
    end
  end

  def unsubscribed
    return_value = false
    if profile_id
      response = GATEWAY.cancel_recurring(profile_id)
      if response.params['ack'] != "Failure"
        self.profile_id = self.status = nil
        save
        return_value = true
      end
    end
    return_value
  end

  private

  def credit_card_payment(plan, credit_card, card_expires_on)
    credit_card[:year] = card_expires_on[:"(1i)"].to_i
    credit_card[:month] = card_expires_on[:"(2i)"].to_i
    h = {:credit_card => credit_card}
    credit_card = ActiveMerchant::Billing::CreditCard.new(h[:credit_card])
    options = {
        :description => "DESCRIPTION_TEXT",
        :start_date => Date.today,
        :period => 'Month',
        :frequency => 1,
        :cycles => plan.duration.to_i || 1
    }
    GATEWAY.recurring(plan.price.to_i*100 || 0, credit_card, options )
  end

end
