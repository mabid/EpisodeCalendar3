require File.dirname(__FILE__) + '/../../config/environment'

namespace :subscription do
  desc "This task checks subscription status of all users"

  task :check_subscription do
    Subscription.where("profile_id is NOT ?",nil).each do |sub|
      response = sub.status
      if response.params['profile_status'] != 'ActiveProfile' || response.params['outstanding_balance'].to_i > 0
        charge_status = @subscription.charge
        if charge_status != false && charge_status.params['ack'] == 'Failure' && charge_status.params['message'] != "Outstanding balance must be > 0"
          @subscription.suspend
        else
          @subscription.reactivate
        end
      end
    end
  end

end