class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      t.integer :api_show_id
      t.integer :number
      t.integer :episodes_count
      t.timestamps
    end
    add_index :seasons, [:api_show_id]
  end
  
  def self.down
    drop_table :seasons
  end
end
