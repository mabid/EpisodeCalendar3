class CreateHiddenEpisodes < ActiveRecord::Migration
  def self.up
    create_table :hidden_episodes do |t|
      t.integer :user_id
      t.integer :season_id
      t.integer :episode_id
      t.timestamps
    end
    add_index :hidden_episodes, [:user_id]
    add_index :hidden_episodes, [:user_id, :season_id]
  end

  def self.down
    drop_table :hidden_episodes
  end
end
