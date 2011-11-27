class AddHiddenEpisodesCountToFollowings < ActiveRecord::Migration
  def change
    add_column :followings, :hidden_episodes_count, :integer, :default => 0
  end
end
