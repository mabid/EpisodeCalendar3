class AddIndexToSeenEpisodes < ActiveRecord::Migration
  def change
  	add_index :seen_episodes, :episode_id
  end
end