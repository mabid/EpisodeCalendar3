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
	belongs_to :user, :counter_cache => true, :touch => true
	belongs_to :show, :counter_cache => :followers

  scope :current, where("watch_later = ?", false)
	
	before_destroy :delete_seen_episodes, :delete_hidden_episodes
	
	def unseen_count
    aired_episodes = Episode.where("show_id = ? AND air_date <= ?", self.show_id, $TODAY).all
	  count = aired_episodes.size - self.marked_episodes_count - self.hidden_episodes_count
  end

  def cached_show
    Rails.cache.fetch([self, :show]) do
      show      
    end
  end
  
  private
  
    def delete_seen_episodes
      episodes = Episode.where(:show_id => self.show_id).all
      SeenEpisode.delete_all(["user_id = ? AND episode_id IN (?)", self.user_id, episodes.collect(&:id)])
    end
  
    def delete_hidden_episodes
      episodes = Episode.where(:show_id => self.show_id).all
      HiddenEpisode.delete_all(["user_id = ? AND episode_id IN (?)", self.user_id, episodes.collect(&:id)])
    end
  
end
