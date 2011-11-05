# == Schema Information
#
# Table name: update_queues
#
#  id          :integer(4)      not null, primary key
#  api_id      :integer(4)
#  update_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class UpdateQueue < ActiveRecord::Base
  
  named_scope :shows, :conditions => { :update_type => "show" }
  named_scope :episodes, :conditions => { :update_type => "episode" }
  named_scope :show_episodes, :conditions => { :update_type => "all_episodes" }
  named_scope :show_banners, :conditions => { :update_type => "banner" }
  
  attr_accessible :api_id, :update_type
end

