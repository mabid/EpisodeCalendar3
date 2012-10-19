class CreateCrons < ActiveRecord::Migration
  def self.up
    create_table :crons do |t|
      t.string :title
      t.integer :every
      t.string :interval
      t.integer :at
      t.string :am_pm
      t.text :command
      t.string :command_type
      t.timestamps
    end
    add_index :crons, [:title]
  end
  
  def self.down
    drop_table :crons
  end
end
