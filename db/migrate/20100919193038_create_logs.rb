class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :key
      t.string :value
      t.text :additional_data
      t.timestamps
    end
    add_index :logs, [:key]
  end
  
  def self.down
    drop_table :logs
  end
end
