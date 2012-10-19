class CreateFollowings < ActiveRecord::Migration
  def self.up
    create_table :followings do |t|
      t.integer :user_id
      t.integer :show_id
      t.boolean :send_reminder
			t.integer :marked_episodes_count, :default => 0
      t.timestamps
    end
    add_index :followings, [:user_id]
    add_index :followings, [:user_id, :show_id]
  end

  def self.down
    drop_table :followings
  end
end
