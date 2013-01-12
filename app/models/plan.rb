class Plan < ActiveRecord::Base
  has_many  :subscriptions
  has_many  :payments
  has_many  :users, :through => :subscriptions
end
