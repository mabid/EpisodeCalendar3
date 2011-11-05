class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.integer :show_id
      t.integer :api_episode_id
      t.integer :season_id
      t.integer :season_number
      t.integer :number
      t.string :name
      t.datetime :air_date
      t.text :overview
      t.float :rating
      t.integer :api_updated_at
      t.timestamps
    end
    add_index :episodes, [:api_episode_id], :unique => true, :name => "episode_must_be_unique"
    add_index :episodes, [:show_id, :air_date]
  end
  
  def self.down
    drop_table :episodes
  end
end
