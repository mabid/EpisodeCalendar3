# == Schema Information
#
# Table name: tickets
#
#  id         :integer(4)      not null, primary key
#  from       :string(255)
#  email      :string(255)
#  category   :string(255)
#  subject    :string(255)
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#

class Ticket < ActiveRecord::Base
  
  validates_presence_of :category, :subject, :message
  validates_presence_of :email, :unless => :logged_in?
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  attr_accessor :is_user, :human
  attr_accessible :from, :email, :category, :subject, :message, :human
  
  def logged_in?
    self.is_user
  end
  
end
