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
  
  default_scope order("created_at desc").limit(25)
  scope :shows_updated, where(:key => "shows_updated")
  scope :episodes_updated, where(:key => "episodes_updated")
  scope :banners_updated, where(:key => "banners_updated")
  scope :show_trends_updated, where(:key => "show_trends_updated")
  scope :show_requested, where(:key => "show_requested")
  
  def failed?
    value.blank?
  end
  
end
