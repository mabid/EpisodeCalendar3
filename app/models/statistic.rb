class Statistic < ActiveRecord::Base

	scope :seen_episodes, where(key: "seen_episodes")

end
