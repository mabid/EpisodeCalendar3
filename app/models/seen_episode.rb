# == Schema Information
#
# Table name: seen_episodes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  season_id  :integer(4)
#  episode_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class SeenEpisode < ActiveRecord::Base
  attr_accessible :user_id, :season_id, :episode_id
  belongs_to :episode
  belongs_to :season
end

