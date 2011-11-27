class MailBalancer < ActiveRecord::Base
  def self.today
    where("date = ?", Date.today)
  end
end
