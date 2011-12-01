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
  
  scope :shows, where(:update_type => "show")
  scope :episodes, where(:update_type => "episode")
  scope :show_episodes, where(:update_type => "all_episodes")
  scope :show_banners, where(:update_type => "banner")
  
  attr_accessible :api_id, :update_type
end

