class CreateConstants < ActiveRecord::Migration
  def self.up
    create_table :constants do |t|
      t.string :key
      t.string :value
      t.string :additional_data
      t.timestamps
    end
    add_index :constants, [:key]
  end
  
  def self.down
    drop_table :constants
  end
end
