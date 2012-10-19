class AddDayOffsetToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :day_offset, :integer, :default => 0
  end

  def self.down
    remove_column :users, :day_offset
  end
end
