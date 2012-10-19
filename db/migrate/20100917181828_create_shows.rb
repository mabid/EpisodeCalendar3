class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.integer :api_show_id
      t.string :name
      t.string :permalink
      t.text :overview
      t.string :status
      t.datetime :first_aired
      t.integer :air_time_hour, :default => 0
      t.integer :day_of_week
      t.integer :runtime, :default => 0
      t.string :network
      t.string :imdb_id
      t.integer :followers, :default => 0
      t.integer :current_trend_position
      t.integer :previous_trend_position
      t.integer :previous_trend_position_followers
      t.integer :seasons_count, :default => 0
      t.integer :episodes_count, :default => 0
      t.integer :api_updated_at
      t.timestamps
    end
    add_index :shows, [:api_show_id], :unique => true, :name => "show_must_be_unique"
    add_index :shows, [:followers]
    add_index :shows, [:status]
    add_index :shows, [:name]
  end
  
  def self.down
    drop_table :shows
  end
end
