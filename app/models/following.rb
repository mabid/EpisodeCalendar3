# == Schema Information
#
# Table name: followings
#
#  id                    :integer(4)      not null, primary key
#  user_id               :integer(4)
#  show_id               :integer(4)
#  send_reminder         :boolean(1)
#  created_at            :datetime
#  updated_at            :datetime
#  marked_episodes_count :integer(4)      default(0)
#  last_marked_episode   :string(45)
#

class Following < ActiveRecord::Base
	belongs_to :user, :counter_cache => true
	belongs_to :show, :counter_cache => :followers
	
	before_destroy :delete_seen_episodes
	
	def unseen_count
	  aired_episodes = Episode.find(:all, :conditions => ["show_id = ? AND air_date <= ?", self.show_id, $TODAY])
	  count = aired_episodes.size - self.marked_episodes_count
  end
  
  private
  
    def delete_seen_episodes
      episodes = Episode.find(:all, :conditions => { :show_id => self.show_id })
      SeenEpisode.find(:all, :conditions => ["user_id = ? AND episode_id IN (?)", self.user_id, episodes.collect(&:id)]).each do |seen_episode|
        seen_episode.destroy
      end
    end
  
end
