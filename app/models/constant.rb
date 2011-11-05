# == Schema Information
#
# Table name: constants
#
#  id              :integer(4)      not null, primary key
#  key             :string(255)
#  value           :string(255)
#  additional_data :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Constant < ActiveRecord::Base
  attr_accessible :key, :value, :additional_data
  
  scope :ticket_categories, :conditions => { :key => "ticket_category" }
  scope :command_types, :conditions => { :key => "command_type" }
  scope :mobile_login, :conditions => { :key => "mobile_login" }
  
  default_scope :order => "`key` asc"
end
