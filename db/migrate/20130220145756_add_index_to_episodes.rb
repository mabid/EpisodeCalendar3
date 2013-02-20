class AddIndexToEpisodes < ActiveRecord::Migration
  def change
  	add_index :episodes, :season_id
  end
end
