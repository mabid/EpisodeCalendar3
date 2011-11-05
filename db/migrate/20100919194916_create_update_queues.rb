class CreateUpdateQueues < ActiveRecord::Migration
  def self.up
    create_table :update_queues do |t|
      t.integer :api_id
      t.string :update_type
      t.timestamps
    end
    add_index :update_queues, [:update_type]
  end
  
  def self.down
    drop_table :update_queues
  end
end
