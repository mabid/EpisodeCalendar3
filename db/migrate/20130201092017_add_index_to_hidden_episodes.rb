class AddIndexToHiddenEpisodes < ActiveRecord::Migration
  def change
  	add_index :hidden_episodes, :episode_id
  end
end
