# == Schema Information
#
# Table name: logs
#
#  id              :integer(4)      not null, primary key
#  key             :string(255)
#  value           :string(255)
#  additional_data :text
#  created_at      :datetime
#  updated_at      :datetime
#

class Log < ActiveRecord::Base
  attr_accessible :key, :value, :additional_data
  
  default_scope :order => "created_at desc", :limit => 25
  scope :shows_updated, :conditions => { :key => "shows_updated" }
  scope :episodes_updated, :conditions => { :key => "episodes_updated" }
  scope :banners_updated, :conditions => { :key => "banners_updated" }
  scope :show_trends_updated, :conditions => { :key => "show_trends_updated" }
  scope :show_requested, :conditions => { :key => "show_requested" }
  
  def failed?
    value.blank?
  end
  
end
