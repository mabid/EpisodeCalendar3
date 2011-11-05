class CreateSeenEpisodes < ActiveRecord::Migration
  def self.up
    create_table :seen_episodes do |t|
      t.integer :user_id
      t.integer :season_id
      t.integer :episode_id
      t.timestamps
    end
    add_index :seen_episodes, [:user_id]
    add_index :seen_episodes, [:user_id, :season_id]
  end
  
  def self.down
    drop_table :seen_episodes
  end
end
