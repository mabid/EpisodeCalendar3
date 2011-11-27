class RemoveLastMarkedEpisodeFromFollowings < ActiveRecord::Migration
  def up
    remove_column :followings, :last_marked_episode
  end

  def down
    add_column :followings, :last_marked_episode, :string
  end
end